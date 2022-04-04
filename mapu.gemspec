Gem::Specification.new do |s|
  s.name = 'mapu'
  s.version = '0.0.1'
  s.date = 04/04/22
  s.summary = "mapu is a micro mini web framework"
  s.authors = ["xxanon"]
  s.email = "ironald@gmail.com"
  s.files = `git ls-files`.split("\n") - %w[bin misc]
  s.executables += `git ls-files bin`.split("\n").map{|e| File.basename(e)}
  s.homepage = "https://github.com/nonnax/mapu.git"
  s.license = "GPL-3.0"
end
