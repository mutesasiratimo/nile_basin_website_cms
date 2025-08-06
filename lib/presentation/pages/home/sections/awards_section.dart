import 'package:flutter/material.dart';
import 'package:nimbus/presentation/layout/adaptive.dart';
import 'package:nimbus/presentation/widgets/bullet_text.dart';
import 'package:nimbus/presentation/widgets/content_area.dart';
import 'package:nimbus/presentation/widgets/nimbus_info_section.dart';
import 'package:nimbus/presentation/widgets/spaces.dart';
import 'package:nimbus/values/values.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AwardsSection extends StatefulWidget {
  AwardsSection({Key? key});
  @override
  _AwardsSectionState createState() => _AwardsSectionState();
}

class _AwardsSectionState extends State<AwardsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool text1InView = false;
  bool text2InView = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _controller.forward();
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = widthOfScreen(context) - (getSidePadding(context));
    double screenHeight = heightOfScreen(context);
    double contentAreaWidth = responsiveSize(
      context,
      screenWidth,
      screenWidth * 0.5,
      md: screenWidth * 0.5,
    );
    double contentAreaHeight = screenHeight * 0.9;
    return VisibilityDetector(
      key: Key('awards-section'),
      onVisibilityChanged: (visibilityInfo) {
        double visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 50) {
          setState(() {
            text1InView = true;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: getSidePadding(context)),
        child: ResponsiveBuilder(
          refinedBreakpoints: RefinedBreakpoints(),
          builder: (context, sizingInformation) {
            double screenWidth = sizingInformation.screenSize.width;
            if (screenWidth <= 1024) {
              return Column(
                children: [
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      double screenWidth = sizingInformation.screenSize.width;
                      if (screenWidth < (RefinedBreakpoints().tabletSmall)) {
                        return _buildNimbusInfoSectionSm();
                      } else {
                        return _buildNimbusInfoSectionLg();
                      }
                    },
                  ),
                  SpaceH50(),
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      double screenWidth = sizingInformation.screenSize.width;
                      if (screenWidth < (RefinedBreakpoints().tabletSmall)) {
                        return _buildImage(
                          width: screenWidth,
                          height: screenHeight * 0.5,
                        );
                      } else {
                        return Center(
                          child: _buildImage(
                            width: screenWidth * 0.75,
                            height: screenHeight * 0.75,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentArea(
                    width: contentAreaWidth,
                    height: contentAreaHeight,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Spacer(),
                                _buildNimbusInfoSectionLg(),
                                Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildImage(
                    width: contentAreaWidth,
                    height: contentAreaHeight,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNimbusInfoSectionSm() {
    return NimbusInfoSection2(
      sectionTitle: StringConst.MY_AWARDS,
      title1: StringConst.AWARDS_TITLE,
      hasTitle2: false,
      body: StringConst.AWARDS_DESC,
      child: Column(
        children: [
          _buildPartnersSection(),
          SpaceH40(),
        ],
      ),
    );
  }

  Widget _buildNimbusInfoSectionLg() {
    return NimbusInfoSection1(
      sectionTitle: StringConst.MY_AWARDS,
      title1: StringConst.AWARDS_TITLE,
      hasTitle2: false,
      body: StringConst.AWARDS_DESC,
      child: Container(
        child: _buildPartnersSection(),
      ),
    );
  }

  Widget _buildImage({
    required double width,
    required double height,
  }) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? titleStyle = textTheme.bodyLarge?.merge(
      Styles.customTextStyle3(
        fontSize: responsiveSize(context, 64, 80, md: 76),
        height: 1.25,
        color: AppColors.primaryColor,
      ),
    );
    double textPosition = assignWidth(context, 0.1);
    return ContentArea(
      width: width,
      height: height,
      child: Stack(
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: ResponsiveBuilder(
                  refinedBreakpoints: RefinedBreakpoints(),
                  builder: (context, sizingInformation) {
                    double screenWidth = sizingInformation.screenSize.width;
                    if (screenWidth < (RefinedBreakpoints().tabletSmall)) {
                      return RotationTransition(
                        turns: _controller,
                        child: Image.asset(
                          ImagePath.DOTS_GLOBE_YELLOW,
                          width: Sizes.WIDTH_150,
                          height: Sizes.HEIGHT_150,
                        ),
                      );
                    } else {
                      return RotationTransition(
                        turns: _controller,
                        child: Image.asset(
                          ImagePath.DOTS_GLOBE_YELLOW,
                        ),
                      );
                    }
                  },
                ),
              ),
              Image.asset(
                ImagePath.DEV_AWARD,
              ),
              AnimatedPositioned(
                left: text1InView ? textPosition : -150,
                child: Text(StringConst.MY, style: titleStyle),
                curve: Curves.fastOutSlowIn,
                onEnd: () {
                  setState(() {
                    text2InView = true;
                  });
                },
                duration: Duration(milliseconds: 750),
              ),
              AnimatedPositioned(
                right: text2InView ? textPosition : -150,
                child: Text(StringConst.CV, style: titleStyle),
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 750),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersSection() {
    TextTheme textTheme = Theme.of(context).textTheme;

    // List of partner images to use in the carousel
    List<String> partnerImages = [
      ImagePath.PARTNERS_1,
      ImagePath.PARTNERS_2,
      ImagePath.PARTNERS_3,
      ImagePath.PARTNERS_4,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Some of our partners",
          style: textTheme.headlineSmall?.copyWith(
            fontSize: responsiveSize(
              context,
              Sizes.TEXT_SIZE_20,
              Sizes.TEXT_SIZE_24,
            ),
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        SpaceH24(),
        Container(
          height: 120,
          child: CarouselSlider.builder(
            itemCount: partnerImages.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    partnerImages[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 80,
              viewportFraction: 0.3, // Show 2 items at a time with some spacing
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              padEnds: false,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAwards(List<String> awards) {
    List<Widget> items = [];
    for (int index = 0; index < awards.length; index++) {
      items.add(TextWithBullet(text: awards[index]));
      items.add(SpaceH16());
    }
    return items;
  }
}
