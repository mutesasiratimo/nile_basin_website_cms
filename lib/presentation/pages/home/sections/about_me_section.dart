import 'package:flutter/material.dart';
import 'package:nimbus/presentation/layout/adaptive.dart';
import 'package:nimbus/presentation/widgets/content_area.dart';
import 'package:nimbus/presentation/widgets/empty.dart';
import 'package:nimbus/presentation/widgets/nimbus_info_section.dart';
import 'package:nimbus/presentation/widgets/spaces.dart';
import 'package:nimbus/utils/functions.dart';
import 'package:nimbus/values/values.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../widgets/buttons/nimbus_button.dart';

const double kSpacingSm = 40.0;
const double kRunSpacingSm = 24.0;
const double kSpacingLg = 24.0;
const double kRunSpacingLg = 16.0;

class AboutMeSection extends StatefulWidget {
  AboutMeSection({Key? key});
  @override
  _AboutMeSectionState createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _fadeInController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeInController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = widthOfScreen(context) - getSidePadding(context);
    double screenHeight = heightOfScreen(context);
    double contentAreaWidthSm = screenWidth * 1.0;
    double contentAreaHeightSm = screenHeight * 0.6;
    double contentAreaWidthLg = screenWidth * 0.5;
    return VisibilityDetector(
      key: Key('about-section'),
      onVisibilityChanged: (visibilityInfo) {
        double visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage > 25) {
          _scaleController.forward();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: getSidePadding(context)),
        child: SingleChildScrollView(
          child: ResponsiveBuilder(
            refinedBreakpoints: RefinedBreakpoints(),
            builder: (context, sizingInformation) {
              double screenWidth = sizingInformation.screenSize.width;
              if (screenWidth < (RefinedBreakpoints().tabletLarge)) {
                return Column(
                  children: [
                    ContentArea(
                      width: contentAreaWidthSm,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: contentAreaWidthSm,
                          maxHeight: contentAreaHeightSm,
                        ),
                        child: _buildImage(
                          width: contentAreaWidthSm,
                          height: contentAreaHeightSm,
                        ),
                      ),
                    ),
                    SpaceH40(),
                    ContentArea(
                      width: contentAreaWidthSm,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: contentAreaWidthSm,
                          maxHeight: screenHeight * 0.8,
                        ),
                        child: _buildAboutMe(
                          width: contentAreaWidthSm,
                          height: screenHeight,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    ContentArea(
                      width: contentAreaWidthLg,
                      child: _buildImage(
                        width: contentAreaWidthLg,
                        height: screenHeight,
                      ),
                    ),
                    ContentArea(
                      width: contentAreaWidthLg,
                      child: _buildAboutMe(
                        width: contentAreaWidthLg,
                        height: screenHeight,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage({required double width, required double height}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: height * 0.1,
          right: -(width * 0.15),
          child: ResponsiveBuilder(
            refinedBreakpoints: RefinedBreakpoints(),
            builder: (context, sizingInformation) {
              double screenWidth = sizingInformation.screenSize.width;
              if (screenWidth < (RefinedBreakpoints().tabletLarge)) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: width * 0.25,
                    maxHeight: height * 0.25,
                  ),
                  child: Image.asset(
                    ImagePath.BLOB_BLACK,
                    fit: BoxFit.contain,
                  ),
                );
              } else {
                return Empty();
              }
            },
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  ImagePath.DOTS_GLOBE_GREY,
                  width: 180,
                  height: 180,
                ),
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: width * 0.95,
                  maxHeight: height * 0.8,
                ),
                child: Image.asset(
                  ImagePath.DEV_ABOUT_ME,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: height * 0.1,
          left: width * 0.1,
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.3,
                maxHeight: height * 0.3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Spacer()],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMe({
    required double width,
    required double height,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //positions blob on the far right of the section
        //based on the calculation only 10% of blob is showing
        Positioned(
          top: height * 0.2,
          left: width * 0.85,
          child: ResponsiveBuilder(
            refinedBreakpoints: RefinedBreakpoints(),
            builder: (context, sizingInformation) {
              double screenWidth = sizingInformation.screenSize.width;
              if (screenWidth < (RefinedBreakpoints().tabletLarge)) {
                return Empty();
              } else {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: width * 0.25,
                    maxHeight: height * 0.25,
                  ),
                  child: Image.asset(
                    ImagePath.BLOB_BLACK,
                    fit: BoxFit.contain,
                  ),
                );
              }
            },
          ),
        ),

        ResponsiveBuilder(
          refinedBreakpoints: RefinedBreakpoints(),
          builder: (context, sizingInformation) {
            double screenWidth = sizingInformation.screenSize.width;
            if (screenWidth < (RefinedBreakpoints().tabletNormal)) {
              return nimbusInfoSectionSm(width: width);
            } else {
              //This container takes 80% of the space and leave 20% as spacing
              //between the blob and the content
              return Container(
                width: width * 0.80,
                child: nimbusInfoSectionLg(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget nimbusInfoSectionLg() {
    // TextTheme textTheme = Theme.of(context).textTheme;
    double buttonWidth = responsiveSize(
      context,
      120,
      200,
    );
    double buttonHeight = responsiveSize(
      context,
      48,
      60,
      md: 54,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NimbusInfoSection1(
                sectionTitle: StringConst.ABOUT_ME,
                title1: StringConst.CREATIVE_DESIGN,
                title2: StringConst.HELP,
                body: StringConst.ABOUT_ME_DESC,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NimbusButton(
                      width: buttonWidth,
                      height: buttonHeight,
                      buttonTitle: StringConst.DOWNLOAD_BROCHURE,
                      buttonColor: AppColors.primaryColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget nimbusInfoSectionSm({required double width}) {
    double buttonWidth = responsiveSize(
      context,
      120,
      200,
    );
    double buttonHeight = responsiveSize(
      context,
      48,
      60,
      md: 54,
    );
    return NimbusInfoSection2(
      sectionTitle: StringConst.ABOUT_ME,
      title1: StringConst.CREATIVE_DESIGN,
      title2: StringConst.HELP,
      body: StringConst.ABOUT_ME_DESC,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NimbusButton(
            width: buttonWidth,
            height: buttonHeight,
            buttonTitle: StringConst.DOWNLOAD_BROCHURE,
            buttonColor: AppColors.primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
