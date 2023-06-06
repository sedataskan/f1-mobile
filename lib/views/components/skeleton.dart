import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 15; i++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _skeletonAvatar(),
                    SizedBox(width: 20),
                    _skeletonLine(context),
                    SizedBox(width: 20),
                    _skeletonLine(context),
                    SizedBox(width: 20),
                    _skeletonLine(context)
                  ],
                ),
                SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

SkeletonAvatar _skeletonAvatar() {
  return SkeletonAvatar(
    style: SkeletonAvatarStyle(
      height: 50,
      width: 50,
      shape: BoxShape.circle,
    ),
  );
}

SkeletonLine _skeletonLine(BuildContext context) {
  return SkeletonLine(
    style: SkeletonLineStyle(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.2,
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
