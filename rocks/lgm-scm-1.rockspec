package = "lgm"
version = "scm-1"

source = {
  url = "git://github.com/unifyid/lgm",
  tag = "master"
}

description = {
  summary = "DSP in Torch",
  detailed = [[
  ]],
  homepage = "https://github.com/unifyid/lgm",
  license = "MIT"
}

dependencies = {
  "torch >= 7.0",
}

build = {
  type = "command",
  build_command = [[
cmake -E make_directory build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)" && $(MAKE)
]],
install_command = "cd build && $(MAKE) install"
}
