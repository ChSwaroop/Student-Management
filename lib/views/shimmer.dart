import 'package:flutter/material.dart';
import 'package:student_mng/util/constants.dart';
import 'package:student_mng/util/reusables.dart';

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({super.key});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, ind) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Reusable.container(
                        shimmerColor,
                        360,
                        100,
                        100,
                        const SizedBox(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            box(360, 20, 90),
                            const SizedBox(height: 8),
                            box(360, 20, 90),
                            const SizedBox(height: 8),
                            box(360, 20, 60),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          box(360, 20, 60),
                          SizedBox(height: 10,),
                          box(360, 20, 60),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Widget box(double radius, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey.shade300),
    );
  }
}
