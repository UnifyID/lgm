# LGM

*Signal processing in Torch*

## Installation

1. install [spuce](https://github.com/audiofilter/spuce)
2. `mkdir build && cd build`
3. `cmake .. && make`
4. `ln -s $(pwd)/.. ~/torch/install/share/lua/5.1`
5. `ln -s $(pwd)/liblgm.so ~/torch/install/lib/lua/5.1`

## Example

```moonscript
lgm = require 'lgm'

SAMPLE_FREQ = 100
CUTOFF_FREQ = 10
NYQUIST_FREQ = 2 * SAMPLE_FREQ
FCD = CUTOFF_FREQ/NYQUIST_FREQ

filt = lgm.designIIR(lgm.IIR.CHEBY1, 8, FCD, 0.001)
x = torch.randn(100)\add(42)
xf = lgm.filtfilt(filt, x)
lgm.destroyFilter(filt)
```
