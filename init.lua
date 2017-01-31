local ffi = require 'ffi'

lgm = {}

ffi.cdef[[
void designIIR(void** filt, const char* iirType, const char* filtType, const int ord,
    const double fc, const double rp, const double stopAttn, const double centerFreq);
void filtfilt(void** filt, THDoubleTensor* in, THDoubleTensor* out);
void undesignIIR(void** filt);
void upsample(THDoubleTensor* in, double rate, THDoubleTensor* out, int order);
]]

lgm.C = ffi.load(package.searchpath('liblgm', package.cpath))

lgm.IIR = {
  CHEBY1='chebyshev',
  CHEBY2='chebychev2',
  BUTTER='butterworth',
  ELLIPTIC='elliptic',
}

lgm.PASS = {
  LOW = 'LOW_PASS',
  HIGH = 'HIGH_PASS',
  BAND = 'BAND_PASS',
  STOP = 'BAND_STOP',
}

function lgm.designIIR(iirType, order, cutoff, ripple, filtType, stopAttn, centerFreq)
  ripple = ripple or 1
  filtType = filtType or lgm.PASS.LOW
  stopAttn = stopAttn or 0
  centerFreq = centerFreq or 0

  local filt = ffi.new('void*[1]')
  lgm.C.designIIR(filt, iirType, filtType, order, cutoff, ripple, stopAttn, centerFreq)
  return filt
end

function lgm.filtfilt(filt, vec)
  local out = vec.new()
  lgm.C.filtfilt(filt, vec:cdata(), out:cdata())
  return out
end

function lgm.destroyFilter(filt)
  lgm.C.undesignIIR(filt)
end

function lgm.upsample(vec, rate, order)
  order = order or 2
  local out = vec.new()
  lgm.C.upsample(vec:cdata(), rate, out:cdata(), order)
  return out
end

return lgm
