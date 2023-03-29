capture = (cmd, raw) ->
  f = assert io.popen cmd, "r"
  s = assert f\read "*a"
  f\close!
  return s if raw
  s = s\gsub "^%s+", ""
  s = s\gsub "%s+$", ""
  s = s\gsub "[\n\r]+", ""
  return s

tasks:
  build: => sh "yue ."
  clean: =>
    fs.remove "envmgr.lua"
    fs.removedirs "bin"
  bin: =>
    SHEBANG = "#!#{capture 'which lua | head -n 1'}"
    fs.mkdir "bin" unless fs.exists "bin"
    sh "echo '#{SHEBANG}\n' > bin/envmgr"
    sh "cat envmgr.lua >> bin/envmgr"
    sh "chmod +x bin/envmgr"
  copy: =>
    fs.copy "bin/envmgr", "#{os.getenv 'HOME'}/bin/envmgr"
