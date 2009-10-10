require 'brewkit'

class Advancecomp <Formula
  url 'http://prdownloads.sourceforge.net/advancemame/advancecomp-1.15.tar.gz'
  md5 'bb236d8bee6fa473d34108cda1e09076'
  homepage 'http://advancemame.sourceforge.net/comp-readme.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
