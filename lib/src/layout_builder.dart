import 'package:flutter/material.dart';
import 'utils.dart';

typedef AdLayoutBuilder = AdLinearLayout Function(
  AdRatingBarView ratingBar,
  AdMediaView media,
  AdImageView icon,
  AdTextView headline,
  AdTextView advertiser,
  AdTextView body,
  AdTextView price,
  AdTextView store,
  AdTextView attribuition,
  AdButtonView button,
);

/// Expands the view to fit the parent size. Same as `double.infinity`
const double MATCH_PARENT = -1;
/// Wrap the content to its own size
const double WRAP_CONTENT = -2;

class AdView {
  /// The radius of the view
  final AdBorderRadius borderRadius;

  /// The padding applied to the view. Default to none
  final EdgeInsets padding;

  /// The margin applied to the view. Default to none
  final EdgeInsets margin;

  /// The background color applied to the view.
  /// Some colors may not be supported
  final Color backgroundColor;

  /// View border
  final BorderSide border;

  /// The width of the view
  final double width;

  /// The height of the view
  final double height;

  /// The type of the view. Do not change this manually
  final String viewType;

  /// The id of the view. Used to recognize
  String id;

  AdView({
    @required this.viewType,
    this.border,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.backgroundColor,
    this.width,
    this.height,
    this.id,
  });

  Map<String, dynamic> toJson() {
    double width = this.width;
    if (width == double.infinity) width = MATCH_PARENT;

    double height = this.height;
    if (height == double.infinity) height = MATCH_PARENT;

    return {
      // meta
      'id': id,
      'viewType': viewType,
      // padding
      'paddingRight': padding?.right,
      'paddingLeft': padding?.left,
      'paddingTop': padding?.top,
      'paddingBottom': padding?.bottom,
      // margin
      'marginRight': margin?.right,
      'marginLeft': margin?.left,
      'marginTop': margin?.top,
      'marginBottom': margin?.bottom,
      // radius
      'topRightRadius': borderRadius?.topRight,
      'topLeftRadius': borderRadius?.topLeft,
      'bottomRightRadius': borderRadius?.bottomRight,
      'bottomLeftRadius': borderRadius?.bottomLeft,
      // border
      'borderWidth' : border?.width ?? 0,
      'borderColor': border?.color?.toHex(),
      // color
      'backgroundColor': backgroundColor?.toHex(),
      // screen bounds
      'width': width,
      'height': height,
    };
  }
}

const String HORIZONTAL = 'horizontal';
const String VERTICAL = 'vertical';

class AdLinearLayout extends AdView {
  final String orientation;
  final List<AdView> children;

  AdLinearLayout({
    this.orientation = VERTICAL,
    @required this.children,
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    double width,
    double height,
    AdBorderRadius borderRadius,
    BorderSide border,
  })  : assert(orientation != null),
        super(
          id: 'linear_layout',
          viewType: 'linear_layout',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: width ?? MATCH_PARENT,
          height: height ?? WRAP_CONTENT,
          borderRadius: borderRadius,
          border: border,
        );

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    List<Map<String, dynamic>> childrenData = [];
    for (final child in children) childrenData.add(child.toJson());
    json.addAll({
      'children': childrenData,
      'orientation': orientation ?? 'vertical',
    });
    return json;
  }
}

class AdTextView extends AdView {
  /// The style applied to the text view.
  ///
  /// Accepted values:
  /// - color
  /// - fontSize
  /// - fontWeight (only FontWeight.bold)
  /// - letterSpacing
  final TextStyle style;

  /// The text applied to the text view.
  final String text;

  final int minLines;
  final int maxLines;
  final double lineSpacing;

  AdTextView({
    this.style,
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    double width,
    double height,
    AdBorderRadius borderRadius,
    BorderSide border,
    this.minLines,
    this.maxLines,
    this.lineSpacing,
    this.text,
  })  : 
        super(
          viewType: 'text_view',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: width ?? MATCH_PARENT,
          height: height ?? WRAP_CONTENT,
          borderRadius: borderRadius,
          border: border,
        );

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    final style = this.style ??
        TextStyle(
          fontSize: 14,
          color: Color(0xFF000000), // black
        );
    json.addAll({
      'textColor': style.color?.toHex(),
      'textSize': style.fontSize,
      'text': text,
      'letterSpacing': style.letterSpacing,
      'lineSpacing': lineSpacing,
      'minLines': minLines,
      'maxLines': maxLines,
      'bold': style.fontWeight == FontWeight.bold,
    });
    return json;
  }
}

class AdImageView extends AdView {
  AdImageView({
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    double size,
    AdBorderRadius borderRadius,
    BorderSide border,
  }) : super(
          viewType: 'image_view',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: size ?? 40,
          height: size ?? 40,
          borderRadius: borderRadius,
          border: border,
        );
}

class AdMediaView extends AdView {
  AdMediaView({
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    double width,
    double height,
    AdBorderRadius borderRadius,
    BorderSide border,
  }) : super(
          viewType: 'media_view',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: width ?? MATCH_PARENT,
          height: height ?? WRAP_CONTENT,
          borderRadius: borderRadius,
          border: border,
        );
}

class AdRatingBarView extends AdView {
  AdRatingBarView({
    EdgeInsets padding,
    EdgeInsets margin,
    Color backgroundColor,
    double width,
    double height,
    AdBorderRadius borderRadius,
    BorderSide border,
  }) : super(
          viewType: 'rating_bar',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: width ?? WRAP_CONTENT,
          height: height ?? WRAP_CONTENT,
          borderRadius: borderRadius,
          border: border,
        );
}

class AdButtonView extends AdView {

  AdButtonView({
    EdgeInsets padding,
    EdgeInsets margin,
    double width,
    double height,
    AdBorderRadius borderRadius,
    Color backgroundColor,
    BorderSide border,
    // text
    int minLines,
    int maxLines,
    double lineSpacing,
    TextStyle textStyle,
    String text,
  }) : super(
          viewType: 'button_view',
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          width: width ?? MATCH_PARENT,
          height: height ?? WRAP_CONTENT,
          borderRadius: borderRadius,
          border: border,
        );

}