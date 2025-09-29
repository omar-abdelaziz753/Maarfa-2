import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';

typedef ItemBuilder = Widget Function(
    BuildContext context, CustomFloatingNavbarItem items);

class CustomFloatingNavbar extends StatefulWidget {
  final List<CustomFloatingNavbarItem>? items;
  final int? currentIndex;
  final void Function(int val)? onTap;
  final Color? selectedBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? backgroundColor;
  final double? fontSize;
  final double? iconSize;
  final double? dotSize;
  final double? itemBorderRadius;
  final double? borderRadius;
  final ItemBuilder? itemBuilder;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double width;
  final double? elevation;
  final TextStyle? textStyle;

  CustomFloatingNavbar({
    super.key,
    @required this.items,
    @required this.currentIndex,
    @required this.onTap,
    ItemBuilder? itemBuilder,
    this.backgroundColor = Colors.black,
    this.selectedBackgroundColor = Colors.white,
    this.selectedItemColor = Colors.black,
    this.iconSize = 24.0,
    this.dotSize = 10.0,
    this.fontSize = 11.0,
    this.borderRadius = 8,
    this.itemBorderRadius = 8,
    this.unselectedItemColor = Colors.white,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    this.padding = const EdgeInsets.only(bottom: 8, top: 8),
    this.width = double.infinity,
    this.elevation = 0.0,
    this.textStyle,
  })  : assert(items!.length > 1),
        assert(items!.length <= 5),
        assert(currentIndex! <= items!.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              unselectedItemColor: unselectedItemColor,
              selectedItemColor: selectedItemColor,
              borderRadius: borderRadius,
              fontSize: fontSize,
              width: width,
              backgroundColor: backgroundColor,
              currentIndex: currentIndex,
              iconSize: iconSize,
              dotSize: dotSize,
              textStyle: textStyle,
              itemBorderRadius: itemBorderRadius,
              items: items,
              onTap: onTap,
              selectedBackgroundColor: selectedBackgroundColor,
            );

  @override
  CustomFloatingNavbarState createState() => CustomFloatingNavbarState();
}

class CustomFloatingNavbarState extends State<CustomFloatingNavbar> {
  List<CustomFloatingNavbarItem> get items => widget.items!;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: widget.elevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // padding: widget.padding,
            decoration: BoxDecoration(
              // border: Border.all(color: primaryText),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius!),
                  topRight: Radius.circular(widget.borderRadius!)),
              color: white,
            ),
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: items.map((f) {
                return widget.itemBuilder!(context, f);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

ItemBuilder _defaultItemBuilder({
  Function(int val)? onTap,
  List<CustomFloatingNavbarItem>? items,
  int? currentIndex,
  Color? selectedBackgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
  Color? backgroundColor,
  double width = double.infinity,
  double? fontSize,
  double? iconSize,
  double? dotSize,
  double? itemBorderRadius,
  double? borderRadius,
  TextStyle? textStyle,
}) {
  return (BuildContext context, CustomFloatingNavbarItem item) {
    final isSelected = currentIndex == items!.indexOf(item);
    final color = isSelected ? mainColor : grey;

    return Expanded(
      child: InkWell(
        onTap: () => onTap!(items.indexOf(item)),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              item.icon!,
              height: iconSize,
              color: color,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            if (item.showTitleAlways == true || isSelected)
              Text(
                item.title!,
                style: textStyle?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: color,
                    ) ??
                    TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
          ],
        ),
      ),
    );
  };
}
// ItemBuilder _defaultItemBuilder({
//   Function(int val)? onTap,
//   List<CustomFloatingNavbarItem>? items,
//   int? currentIndex,
//   Color? selectedBackgroundColor,
//   Color? selectedItemColor,
//   Color? unselectedItemColor,
//   Color? backgroundColor,
//   double width = double.infinity,
//   double? fontSize,
//   double? iconSize,
//   double? dotSize,
//   double? itemBorderRadius,
//   double? borderRadius,
//   TextStyle? textStyle,
// }) {
//   return (BuildContext context, CustomFloatingNavbarItem item) => Expanded(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               // duration: Duration(milliseconds: 300),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(itemBorderRadius!)),
//               child: InkWell(
//                 onTap: () {
//                   onTap!(items.indexOf(item));
//                 },
//                 borderRadius: BorderRadius.circular(8),
//                 child: Container(
//                   width: width.isFinite
//                       ? (width / items!.length - 8)
//                       : MediaQuery.of(context).size.width / items!.length - 24,
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 4, vertical: item.title != null ? 4 : 8),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       item.customWidget == null
//                           ? currentIndex == items.indexOf(item)
//                               ? Icon(
//                                   Icons.circle,
//                                   color: accentColor,
//                                   size: dotSize,
//                                 )
//                               : Image.asset(item.icon!,
//                                   height: iconSize,
//                                   color: accentColor,
//                                   fit: BoxFit.contain)
//                           : item.customWidget!,
//                       if (currentIndex == items.indexOf(item))
//                         Text(
//                           '${item.title}',
//                           overflow: TextOverflow.ellipsis,
//                           style: textStyle!.copyWith(color: primaryText),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
// }

class CustomFloatingNavbarItem {
  final String? title;
  final String? icon;
  final Widget? customWidget;
  final bool? showTitleAlways;

  CustomFloatingNavbarItem({
    this.icon,
    this.title,
    this.customWidget,
    this.showTitleAlways,
  }) : assert(icon != null || customWidget != null);
}
