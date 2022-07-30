import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperWidget extends StatefulWidget {
  final productMedia;
  final int selectedImage;

  SwiperWidget({@required this.productMedia, this.selectedImage = 0});

  @override
  _SwiperWidgetState createState() => _SwiperWidgetState();
}

class _SwiperWidgetState extends State<SwiperWidget> {
  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    swiperController..move(widget.selectedImage);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "images/Rectangle 61.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              "images/Rectangle 62.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            width: double.infinity,
            height: 260.0,
            child: Center(
              child: Container(
                width: 257.0,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Swiper(
                  outer: true,
                  controller: swiperController,
                  itemCount: widget.productMedia.length,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            offset: Offset(0.0, 4.0), // (x, y)
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.productMedia[index],
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: SwiperCustomPagination(
                      builder:
                          (BuildContext context, SwiperPluginConfig config) {
                        return Container(
                          width: double.infinity,
                          height: 5.0,
                          child: Center(
                            child: SizedBox(
                              width: 100.0,
                              child: Center(
                                child: ListView.separated(
                                  itemCount: config.itemCount,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 7.0),
                                  itemBuilder: (context, index) {
                                    if (index == config.activeIndex) {
                                      return Container(
                                        width: 33.0,
                                        height: 5.0,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: HexColor('#6092DC'),
                                        ),
                                      );
                                    }
                                    return Container(
                                      width: 5.0,
                                      height: 5.0,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            HexColor("#6092DC").withOpacity(.4),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
