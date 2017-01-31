#include <TH/TH.h>
#include <spuce/filters/design_iir.h>
#include <spuce/filters/iir_coeff.h>
#include <spuce/filters/iir.h>
#include <iostream>

#define print(VAL) std::cout << VAL << std::endl; // DEBUGGING

extern "C" {
  void designIIR(void** filt, const char* iirType, const char* filtType, const int ord,
      const double fc, const double rp, const double stopAttn, const double centerFreq);
  void filtfilt(void** filt, THDoubleTensor* in, THDoubleTensor* out);
  void undesignIIR(void** filt);
}

void designIIR(void** filt, const char* iirType, const char* filtType, const int ord,
    const double fc, const double rp, const double stopAttn, const double centerFreq) {
  filt[1] = spuce::design_iir(iirType, filtType, ord, fc, rp, stopAttn, centerFreq);
}

void flip_inplace(double* vec, const size_t n) {
  for (size_t i = 0; i < n/2; ++i) {
    double tmp = vec[n - i - 1];
    vec[n - i - 1] = vec[i];
    vec[i] = tmp;
  }
}

double mean(double* vec, const size_t n) {
  double sum = 0;
  for (size_t i = 0; i < n; ++i) sum += vec[i];
  return sum / n;
}

void filtfilt(void** filt, THDoubleTensor* in, THDoubleTensor* out) {
  spuce::iir_coeff* coeffs = (spuce::iir_coeff*)filt[1];
  spuce::iir<double> sos(*coeffs);

  const int padlen = sos.stages() * 22; // magic
  const size_t n = THDoubleTensor_size(in, 0);
  const double* in_data = THDoubleTensor_data(in);

  std::vector<double> x(n + padlen);
  double* x_data = x.data();

  std::fill_n(x_data, padlen, THDoubleTensor_meanall(in));
  memcpy(x_data + padlen, in_data, n*sizeof(double));

  sos.process_inplace(x);
  flip_inplace(x_data + padlen, n);
  std::fill_n(x_data, padlen, mean(x_data + padlen, n));

  sos.process_inplace(x);
  flip_inplace(x_data + padlen, n);

  THDoubleTensor_resizeAs(out, in);
  memcpy(THDoubleTensor_data(out), x.data()+padlen, n*sizeof(double));
}

void undesignIIR(void** filt) {
  spuce::iir_coeff* iir = (spuce::iir_coeff*)filt[1];
  delete iir;
}
