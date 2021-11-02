import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: PageScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: CustomAppBar2(
            statusBarHeight: MediaQuery.of(context).padding.top,
          )
          ),
          SliverPersistentHeader(
              pinned: true, delegate: CustomTabBar()
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text('Index: $index'),
              ),
                  ),
              childCount: 15
          )
          )

        ],
      ),
    );
  }
}

class CustomAppBar2 extends SliverPersistentHeaderDelegate {

  final double statusBarHeight;
  final double _customerCardMaxHeight = 280.0;
  final double _customerCardMinHeight = 48.0;
  final double _verticalPadding = 16.0;
  final double _expandedPictureRadius = 32.0;
  final double _compactedPictureRadius = 16.0;
  final double _pictureAddedRadius = 4.0;

  // CONSTRUCTOR
  CustomAppBar2({required this.statusBarHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      /// Must be transparent
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            color: Colors.deepPurple,
            height: _calculateBackgroundHeight(shrinkOffset),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                  Spacer(),
                  Opacity(
                      opacity: _calculateAppBarTitleOpacity(shrinkOffset),
                      child: Text('Détail client', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16.0),)
                  ),
                  Spacer(),
                  Icon(Icons.padding, color: Colors.white,),
                ],
              ),
            ),
          ),
          Positioned(
              top: statusBarHeight + kToolbarHeight - _verticalPadding,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                          )
                        ]
                    ),
                    child: SizedBox(
                      height: _calculateCardHeight(shrinkOffset),
                      width: MediaQuery.of(context).size.width - 2 * _verticalPadding,
                    ),
                  ),
                  Positioned(
                    top: _calculatePictureYPosition(shrinkOffset),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: _calculatePictureRadius(shrinkOffset) + _pictureAddedRadius,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: _calculatePictureRadius(shrinkOffset),
                                backgroundImage: CachedNetworkImageProvider('https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60'),
                              ),
                            ),
                            _buildCustomerName(context, shrinkOffset),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        _buildCardContent(context, shrinkOffset)
                      ],
                    ),
                  )
                ],
              )
          )
        ],
      ),

    );
  }

  /// Returns customer name
  Widget _buildCustomerName(BuildContext context, double offset) {
    final Size size = (TextPainter(
      text: TextSpan(text: 'Charlie dupont'),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr
    )..layout()).size;
    final double textWidth = size.width;
    final double textPadding = 8.0;
    if (offset <= _expandedPictureRadius * 3) {
      return SizedBox.shrink();
    } else if (offset > _expandedPictureRadius * 3 && offset <= _expandedPictureRadius * 3 + textWidth + textPadding) {
      return SizedBox(width: offset - _expandedPictureRadius * 3);
    } else if (offset >_expandedPictureRadius * 3 + textWidth + textPadding && offset <= _expandedPictureRadius * 4 + textWidth + textPadding) {
      return SizedBox(
        width: textWidth + textPadding,
        child: Row(
          children: [
            SizedBox(
              width: textPadding,
            ),
            Opacity(
                opacity: (offset - (_expandedPictureRadius * 3 + textWidth + textPadding)) / 100,
                child: Text('Charlie dupont'),
            )
          ],
        ),
      );
    } else
      return SizedBox(
        width: textWidth + textPadding * 2,
        child: Row(
          children: [
            SizedBox(
              width: textPadding,
            ),
            Text('Charlie dupont', style: TextStyle(fontWeight: FontWeight.w700),),
          ],
        ),
      );
  }

  /// Returns customer card content
  Widget _buildCardContent(BuildContext context, double offset) {
    return Opacity(
      opacity: _calculateCardContentOpacity(offset),
      child: Column(
        children: [
          Text('Charlie Dupont', style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700
          ),),
          SizedBox(height: 4.0,),
          Text('0778123456', style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: Colors.grey
          ),),
          SizedBox(height: 4.0,),
          Text('charlie@gmail.com', style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            color: Colors.grey
          ),),
          SizedBox(height: 4.0,),
          Text('3 place de l\'étoile, 38000 Grenoble', style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            color: Colors.deepPurple
          ),),
          // SizedBox(height: 30.0,),
          SizedBox(height: _calculateFlexibleSpaceHeight(offset)),
          SizedBox(
            width: MediaQuery.of(context).size.width - 64.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('Nb réservations'),
                    SizedBox(width: 4.0,),
                    Text('5'),
                  ],
                ),
                SizedBox(width: 8.0,),
                Container(
                  height: 16.0,
                  child: VerticalDivider(
                    width: 2.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 8.0,),
                Row(
                  children: [
                    Text('Total réservation'),
                    SizedBox(width: 4.0,),
                    Text('85.23€'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0,),
          Container(
            height: 62.0,
            width: MediaQuery.of(context).size.width - 64.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey
            ),
          )

        ],
      ),
    );
  }



  @override
  double get maxExtent => statusBarHeight + kToolbarHeight + _customerCardMaxHeight - _verticalPadding;

  @override
  double get minExtent => statusBarHeight + kToolbarHeight + _customerCardMinHeight - _verticalPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  /// Calculate Background height
  double _calculateBackgroundHeight(double offset) {
    if (offset >= 0 && offset < _customerCardMaxHeight - _customerCardMinHeight - 2 * _verticalPadding) {
      return statusBarHeight + kToolbarHeight + _customerCardMaxHeight - 4 * _verticalPadding - offset;
    } else
      return statusBarHeight + kToolbarHeight + _verticalPadding;
  }

  /// Calculate app bar title opacity
  double _calculateAppBarTitleOpacity(double offset) {
    if (offset >=0 && offset < _expandedPictureRadius * 4) {
      return 0.0;
    } else if (offset >= _expandedPictureRadius * 4 && offset < _customerCardMaxHeight - _customerCardMinHeight) {
      return offset / (statusBarHeight + kToolbarHeight + _customerCardMaxHeight - _verticalPadding);
    } else
      return 1.0;
  }

  /// Calculate picture radius
  double _calculatePictureRadius(double offset) {
    if (offset >= 0 && offset < _verticalPadding * 2.5) {
      return _expandedPictureRadius;
    } else if (offset > _verticalPadding * 2.5 && offset <= _expandedPictureRadius) {
      return _expandedPictureRadius  - offset;
    } else {
      return _compactedPictureRadius;
    }
  }

  /// Calculate picture y position
  double _calculatePictureYPosition(double offset) {
    if (offset >= 0 && offset < _verticalPadding * 2.5) {
      return - _expandedPictureRadius;
    } else if (offset >= _verticalPadding * 2.5 && offset < _verticalPadding * 2.5 + _expandedPictureRadius) {
      return offset - _expandedPictureRadius - _verticalPadding * 2.5;
    } else
      return _verticalPadding / 2 - _pictureAddedRadius;
  }

  /// Calculate customer card height
  double _calculateCardHeight(double offset) {
    if (offset >= 0 && offset < _customerCardMaxHeight - _customerCardMinHeight) {
      return _customerCardMaxHeight - offset;
    } else {
      return _customerCardMinHeight;
    }
  }

  /// Calculate card content opacity
  double _calculateCardContentOpacity(double offset) {
    if (offset < _verticalPadding * 2.5) {
      return 1.0 - offset / (_verticalPadding * 2.5);
    } else
      return 0.0;
  }

  /// Calculate flexible space height
  double _calculateFlexibleSpaceHeight(double offset) {
    if (offset < _verticalPadding * 2.5) {
      return _verticalPadding * 2.5 - offset;
    } else
      return _verticalPadding / 2.5;
  }



}



class CustomAppBar extends SliverPersistentHeaderDelegate {

  // PROPERTIES
  final double statusBarHeight;
  final double _expandedHeight = 300.0;
  final double _compactedHeight = 120.0;
  final double _scrollExtent = 150.0;
  final double _customerCardMaxHeight = 280.0;
  final double _customerCarMinHeight = 80.0;
  final double _verticalPadding = 16.0;
  final double _picturePadding = 8.0;
  final double _pictureRadius = 32.0;

  // CONSTRUCTOR
  CustomAppBar({required this.statusBarHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      /// Must be transparent
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            color: Colors.purple,
            height: _calculateBackgroundHeight(shrinkOffset),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.padding, color: Colors.white,),
                  Spacer(),
                  Text('Title', style: TextStyle(color: Colors.white),),
                  Spacer(),
                  Icon(Icons.padding, color: Colors.white,),
                ],
              ),
            ),
          ),
          Positioned(
              top: statusBarHeight + kToolbarHeight - _verticalPadding,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                        )
                      ]
                    ),
                    child: SizedBox(
                      height: 180.0,
                      width: MediaQuery.of(context).size.width - 2 * _verticalPadding,
                    ),
                  ),
                  Positioned(
                    top: _calculatePictureYPosition(shrinkOffset),
                    child: CircleAvatar(
                      radius: _pictureRadius,
                      backgroundColor: Colors.yellow,
                      child: Icon(Icons.title, color: Colors.red,),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  /// Calculate Background height
  double _calculateBackgroundHeight(double offset) {
    if (offset >= 0 && offset < statusBarHeight + kToolbarHeight) {
      return _expandedHeight - offset - statusBarHeight - kToolbarHeight;
    } else
      return statusBarHeight + kToolbarHeight;
  }

  /// Calculate picture y position
  double _calculatePictureYPosition(double offset) {
    if (offset >= 0 && offset < _pictureRadius) {
      return offset - _pictureRadius;
    } else
    return 0.0;
  }


  @override
  // TODO: implement maxExtent
  double get maxExtent => _expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => _compactedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }


}


class CustomTabBar extends SliverPersistentHeaderDelegate {

  final double barHeight = 60.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.tealAccent
            ),
            child: Text('RDV à venir'),
          ),
          SizedBox(
            width: 16.0,
          ),
          Container(
            child: Text('RDV à venir'),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => barHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => barHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
