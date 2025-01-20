import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';
import 'data_source.dart';
import 'constants.dart';
import 'custom_tooltip.dart';

class CenteredSizedBox extends StatelessWidget {
  const CenteredSizedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analysis of Key Products'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: DrillDownTreeMap(),
      ),
    );
  }
}

class DrillDownTreeMap extends StatefulWidget {
  const DrillDownTreeMap({super.key});

  @override
  State<DrillDownTreeMap> createState() => _DrillDownTreeMapState();
}

class _DrillDownTreeMapState extends State<DrillDownTreeMap> {

  late List<ProductSale> _dataSource;

  /// Builds the treemap for first level - Product level.
  TreemapLevel _buildProductTreemapLevel() {
    return TreemapLevel(
      groupMapper: (int index) => _dataSource[index].productName,
      colorValueMapper: (tile) => colors[_dataSource[tile.indices[0]].productName],
      tooltipBuilder: _buildTooltipBuilder(),
      itemBuilder: (context, tile) => ItemBuilder(tile: tile, dataSource: _dataSource, isFirstLevel: true),
    );
  }

  Widget? Function(BuildContext, TreemapTile)? _buildTooltipBuilder() {
    return (BuildContext context, TreemapTile tile) {
      final int index = tile.indices[0];
      final ProductSale productSale = _dataSource[index];
      final List<String> productDetails = <String>[
        if (productSale.state != null) state,
        product,
        amount,
      ];
      final List<String> productValues = <String>[
        if (productSale.state != null) productSale.state!,
        productSale.productName,
        '\$${productSale.salesAmount?.toStringAsFixed(2)}',
      ];

      return CustomTooltip(
        productDetails: productDetails,
        productValues: productValues,
      );
    };
  }

  @override
  void initState() {
    _dataSource = generateProductSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfTreemap(
      dataCount: _dataSource.length,
      weightValueMapper: (int index) => _dataSource[index].salesAmount!,
      tooltipSettings: const TreemapTooltipSettings(color: Colors.black),
      enableDrilldown: true,
      breadcrumbs: TreemapBreadcrumbs(
        builder: (BuildContext context, TreemapTile treemapTile, bool value){
          return Text(treemapTile.group);
        }),
      levels: [
        _buildProductTreemapLevel(),
        _buildTreemapLevel((int index)=> _dataSource[index].countryName),
        _buildTreemapLevel((int index)=> _dataSource[index].state)
      ],
    );
  }

  TreemapLevel _buildTreemapLevel(String? Function(int) groupMapper){
    return TreemapLevel(groupMapper: groupMapper,
      colorValueMapper: (tile) => colors[_dataSource[tile.indices[0]].productName],
      itemBuilder: (context, tile) => 
        ItemBuilder(tile: tile, dataSource: _dataSource, isFirstLevel: false),
      tooltipBuilder: _buildTooltipBuilder());
  }
}

/// Builds the Treemap tiles with product icons for first level.
class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    super.key,
    required this.tile,
    required this.dataSource,
    required this.isFirstLevel,
  });

  final TreemapTile tile;
  final List<ProductSale> dataSource;
  final bool isFirstLevel;

  Widget _buildHeaderText() {
    return Center(
      child: Text(
        tile.group,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String productName = dataSource[tile.indices[0]].productName;
    final IconData? iconData = productIcons[productName];

    return Stack(
      children: <Widget>[
        if (isFirstLevel)
          Positioned.fill(
            child: Icon(
              iconData,
              size: 130.0,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        _buildHeaderText(),
        if(tile.hasDescendants)
          const Padding(padding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.add_circle_outline,
              size: 20.0,
              color: Colors.white,),
          ),)
      ],
    );
  }
}
