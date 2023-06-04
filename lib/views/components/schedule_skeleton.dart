import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 15; i++) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _skeletonAvatar(),
                    SizedBox(width: 20),
                    _skeletonParagraph(context),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

SkeletonParagraph _skeletonParagraph(BuildContext context) {
  return SkeletonParagraph(
    style: SkeletonParagraphStyle(
      spacing: 8,
      lines: 1,
      lineStyle: SkeletonLineStyle(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
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
