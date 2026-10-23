class DublinTraceroute < Formula
  desc "NAT-aware multipath tracerouting tool"
  homepage "https://dublin-traceroute.net"
  url "https://github.com/insomniacslk/dublin-traceroute/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "255980a630fb0d8b1cac270a656d6236bfddc5ba253bda4b898302918caf76d1"
  license "BSD-2-Clause"
  head "https://github.com/insomniacslk/dublin-traceroute.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jsoncpp"
  depends_on "libtins"

  def install
    libtins = formula_opt_prefix("libtins")
    jsoncpp = formula_opt_prefix("jsoncpp")

    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DCMAKE_CXX_FLAGS=-I#{libtins}/include
      -DCMAKE_EXE_LINKER_FLAGS=-L#{jsoncpp}/lib
      -DCMAKE_SHARED_LINKER_FLAGS=-L#{jsoncpp}/lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Dublin Traceroute #{version}", shell_output("#{bin}/dublin-traceroute --version")
  end
end
