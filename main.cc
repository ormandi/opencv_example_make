#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgcodecs.hpp>

#include <cstdio>

int main(int argc, char** argv) {
  if (argc != 2) {
    std::fprintf(stderr, "usage: %s <image>\n", argv[0]);
    return 2;
  }

  // imread reports failure with an empty Mat rather than throwing.
  const cv::Mat image = cv::imread(argv[1], cv::IMREAD_COLOR);
  if (image.empty()) {
    std::fprintf(stderr, "failed to read %s\n", argv[1]);
    return 1;
  }

  std::printf("%s: %dx%d, %d channel(s)\n", argv[1], image.cols, image.rows,
              image.channels());

  const char* kWindow = "image (press any key to close)";
  cv::namedWindow(kWindow, cv::WINDOW_AUTOSIZE);
  cv::imshow(kWindow, image);
  cv::waitKey(0);
  cv::destroyAllWindows();
  return 0;
}
