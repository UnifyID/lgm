# LGM

*Signal processing in Torch*

## Installation

1. install [spuce](https://github.com/audiofilter/spuce)
2. `luarocks build https://raw.githubusercontent.com/unifyid/lgm/master/rocks/lgm-scm-1.rockspec`

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
