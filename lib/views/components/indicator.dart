import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:f1_flutter/constants/colors.dart';
import 'package:flutter/material.dart';

class _Cloud {
  static const _light = AppColors.primaryColorTint20;
  static const _dark = AppColors.primaryColorDark;
  static const _normal = AppColors.white;

  static const _assets = [
    "assets/indicator/cloud1.png",
    "assets/indicator/cloud2.png",
    "assets/indicator/cloud3.png",
    "assets/indicator/cloud4.png",
  ];

  AnimationController? controller;
  final Color? color;
  final AssetImage? image;
  final double? width;
  final double? dy;
  final double? initialValue;
  final Duration? duration;
  _Cloud({
    this.color,
    this.image,
    this.width,
    this.dy,
    this.initialValue,
    this.duration,
  });
}

class PlaneIndicator extends StatefulWidget {
  final Widget child;
  const PlaneIndicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _PlaneIndicatorState createState() => _PlaneIndicatorState();
}

class _PlaneIndicatorState extends State<PlaneIndicator>
    with TickerProviderStateMixin {
  static final _planeTween = CurveTween(curve: Curves.easeInOut);
  late AnimationController _planeController;

  @override
  void initState() {
    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _setupCloudsAnimationControllers();
    super.initState();
  }

  static final _clouds = [
    _Cloud(
      color: _Cloud._dark,
      initialValue: 0.6,
      dy: 10.0,
      image: AssetImage(_Cloud._assets[0]),
      width: 100,
      duration: const Duration(milliseconds: 1600),
    ),
    _Cloud(
      color: _Cloud._light,
      initialValue: 0.15,
      dy: 25.0,
      image: AssetImage(_Cloud._assets[1]),
      width: 40,
      duration: const Duration(milliseconds: 1600),
    ),
    _Cloud(
      color: _Cloud._light,
      initialValue: 0.3,
      dy: 65.0,
      image: AssetImage(_Cloud._assets[2]),
      width: 60,
      duration: const Duration(milliseconds: 1600),
    ),
    _Cloud(
      color: _Cloud._dark,
      initialValue: 0.8,
      dy: 70.0,
      image: AssetImage(_Cloud._assets[3]),
      width: 100,
      duration: const Duration(milliseconds: 1600),
    ),
    _Cloud(
      color: _Cloud._normal,
      initialValue: 0.0,
      dy: 10,
      image: AssetImage(_Cloud._assets[0]),
      width: 80,
      duration: const Duration(milliseconds: 1600),
    ),
    _Cloud(
      color: _Cloud._normal,
      initialValue: 0.7,
      dy: 45.0,
      image: AssetImage(_Cloud._assets[1]),
      width: 80,
      duration: const Duration(milliseconds: 1600),
    ),
  ];

  void _setupCloudsAnimationControllers() {
    for (final cloud in _clouds) {
      cloud.controller = AnimationController(
        vsync: this,
        duration: cloud.duration,
        value: cloud.initialValue,
      );
    }
  }

  void _startPlaneAnimation() {
    _planeController.repeat(reverse: true);
  }

  void _stopPlaneAnimation() {
    _planeController
      ..stop()
      ..animateTo(0.0, duration: const Duration(milliseconds: 100));
  }

  void _stopCloudAnimation() {
    for (final cloud in _clouds) {
      cloud.controller!.stop();
    }
  }

  void _startCloudAnimation() {
    for (final cloud in _clouds) {
      cloud.controller!.repeat();
    }
  }

  void _disposeCloudsControllers() {
    for (final cloud in _clouds) {
      cloud.controller!.dispose();
    }
  }

  @override
  void dispose() {
    _planeController.dispose();
    _disposeCloudsControllers();
    super.dispose();
  }

  static const _offsetToArmed = 150.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final car = AnimatedBuilder(
          animation: _planeController,
          child: Image.asset(
            "assets/indicator/car.png",
            fit: BoxFit.contain,
          ),
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(
                  30 * (0.95 - _planeTween.transform(_planeController.value)),
                  0),
              child: child,
            );
          },
        );

        final way = Container(
          height: 100,
          width: screenWidth * 1.5,
          child: Image.asset("assets/indicator/way.png", fit: BoxFit.cover),
        );

        return CustomRefreshIndicator(
          offsetToArmed: _offsetToArmed,
          child: widget.child,
          autoRebuild: false,
          onStateChanged: (change) {
            if (change.didChange(
              from: IndicatorState.armed,
              to: IndicatorState.settling,
            )) {
              _startCloudAnimation();
              _startPlaneAnimation();
            }
            if (change.didChange(
              from: IndicatorState.loading,
            )) {
              _stopPlaneAnimation();
            }
            if (change.didChange(
              to: IndicatorState.idle,
            )) {
              _stopCloudAnimation();
            }
          },
          onRefresh: () => Future.delayed(const Duration(seconds: 3)),
          builder: (BuildContext context, Widget child,
              IndicatorController controller) {
            return AnimatedBuilder(
              animation: controller,
              child: child,
              builder: (context, child) {
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    if (!controller.side.isNone)
                      Container(
                        height: _offsetToArmed * controller.value,
                        color: AppColors.primaryColorLight,
                        width: double.infinity,
                        child: AnimatedBuilder(
                          animation: _clouds.first.controller!,
                          builder: (BuildContext context, Widget? child) {
                            return Stack(
                              clipBehavior: Clip.hardEdge,
                              children: <Widget>[
                                for (final cloud in _clouds)
                                  Transform.translate(
                                    offset: Offset(
                                      ((screenWidth + cloud.width!) *
                                              cloud.controller!.value) -
                                          cloud.width!,
                                      cloud.dy! * controller.value,
                                    ),
                                    child: OverflowBox(
                                      minWidth: cloud.width,
                                      minHeight: cloud.width,
                                      maxHeight: cloud.width,
                                      maxWidth: cloud.width,
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                        color: cloud.color,
                                        image: cloud.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                OverflowBox(
                                  child: way,
                                  maxWidth: screenWidth * 2,
                                  minWidth: 172,
                                  maxHeight: 50,
                                  minHeight: 50,
                                  alignment: Alignment.bottomCenter,
                                ),

                                /// plane
                                Center(
                                  child: OverflowBox(
                                    child: car,
                                    maxWidth: 300,
                                    minWidth: 172,
                                    maxHeight: 70,
                                    minHeight: 50,
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(0.0, _offsetToArmed * controller.value),
                      child: child,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
