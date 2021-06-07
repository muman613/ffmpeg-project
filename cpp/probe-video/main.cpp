#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>

extern "C" {
    #include <libavcodec/avcodec.h>
    #include <libavformat/avformat.h>

    #include <libavutil/opt.h>
    #include <libavutil/imgutils.h>
}

struct cmdOptions {
    std::string input_filename;
};

using codecDescrVec = std::vector<AVCodecDescriptor>;

static void display_help(const char * cmdname) {
    std::cout << cmdname << " <-h> -i [input_filename]" << std::endl;
    return;
}

bool get_codec_descriptor_vec(codecDescrVec & vec) {
    vec.clear();

    const AVCodecDescriptor * codec_descr{nullptr};
    while (avcodec_descriptor_next(codec_descr)) {
        if (codec_descr->type == AVMEDIA_TYPE_VIDEO)
        vec.push_back(*codec_descr);
    }

    return (!vec.empty());
}

bool parse_args(int argc, char * argv[], cmdOptions & opts) {
    int c;

    while ((c = getopt( argc, argv, "i:h")) != -1) {
        switch (c) {
        case 'i':
            opts.input_filename = optarg;
            break;
        case 'h':
            display_help(argv[0]);
            return false;
        }
    }

    return (!opts.input_filename.empty());
}

int main(int argc, char * argv[]) {
    AVFormatContext * format{nullptr};
    cmdOptions opts;

    avcodec_register_all();
    av_register_all();

    if (parse_args(argc, argv, opts)) {
        std::cout << "Probeing file " << opts.input_filename << std::endl;
        if (avformat_open_input(&format, opts.input_filename.c_str(), nullptr, nullptr) == 0) {
            if (avformat_find_stream_info(format, nullptr) >= 0) {
                AVCodec * video_dec{nullptr};
                const auto video_stream_index = av_find_best_stream( format, AVMEDIA_TYPE_VIDEO, -1, -1, & video_dec, 0 );

                if (video_stream_index >= 0) {
                    const auto videoStream = format->streams[ video_stream_index ];
                    const double FPS = (double)videoStream->r_frame_rate.num / (double)videoStream->r_frame_rate.den;

                    std::cout << opts.input_filename << " Bitrate : " << format->bit_rate/1000 << " fps : " << FPS << std::endl;
                } else {
                    // error
                }
            } else {

            }
        } else {

        }
    }


    return 0;
}