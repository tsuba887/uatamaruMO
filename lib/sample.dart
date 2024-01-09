import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OrderModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Order App',
      theme: ThemeData(
        primaryColor: Color(0xFFFD4701),
        hintColor: Colors.white,
      ),
      home: OrderPage(),
    );
  }
}

class OrderModel with ChangeNotifier {
  int totalAmount = 0;
  List<String> orderHistory = [];
  List<int> orderPrices = [];
  List<String> confirmedOrders = [];
  List<int> confirmedPrices = [];

  void addOrder(String item, int price) {
    totalAmount += price;
    orderHistory.add(item);
    orderPrices.add(price);
    notifyListeners();
  }

  void clearOrder() {
    totalAmount = 0;
    orderHistory.clear();
    orderPrices.clear();
    notifyListeners();
  }

  void saveOrder() {
    confirmedOrders.addAll(orderHistory);
    confirmedPrices.addAll(orderPrices);
    clearOrder();
  }
}

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Order App'),
      ),
      body: Column(
        children: [
          Container(
            height: 56.0,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuButton(context, 'メニュー', MenuCategoryPage('おすすめ')),
                _menuButton(context, 'お会計', CheckoutPage()),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '下のメニューから選択してください。',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(title),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Color(0xFFFD4701),
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final int price;

  Product({required this.name, required this.imageUrl, required this.price});
}

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  ProductGrid(this.products);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // ここにボタンタップ時の処理を追加
                    print('${products[index].name}がタップされました');
                  },
                  child: Image.network(
                    products[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(products[index].name),
                    Text('¥${products[index].price}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class MenuPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(name: '角煮まんじゅう', price: 1000, imageUrl: 'https://1.bp.blogspot.com/-KcgSvjOq-SU/YSWUHcoGqrI/AAAAAAABfW0/aPcOSy9XO34Ixr-sD07IIxtQCC4yH9Q1QCNcBGAsYHQ/s180-c/food_kakuni_manju.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 56.0,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _menuButton(context, 'おすすめ', MenuCategoryPage('おすすめ')),
                _menuButton(context, '牛肉', MenuCategoryPage('牛肉')),
                _menuButton(
                    context, '豚肉・鶏肉', MenuCategoryPage('豚肉・鶏肉')),
                _menuButton(context, 'ホルモン', MenuCategoryPage('ホルモン')),
                _menuButton(context, 'ドリンク', MenuCategoryPage('ドリンク')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(menuItems[index].imageUrl),
                    title: Text(menuItems[index].name),
                    subtitle: Text('${menuItems[index].price}円'),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Provider.of<OrderModel>(context, listen: false)
                            .addOrder(menuItems[index].name, menuItems[index].price);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingCartPage()),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(title),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Color(0xFFFD4701),
      ),
    );
  }
}

class MenuCategoryPage extends StatelessWidget {
  final String categoryName;

  MenuCategoryPage(this.categoryName);

  // サンプルデータ
  final List<Product> sampleProducts = List.generate(
    10,
        (index) => Product(
      name: '商品$index',
      imageUrl: 'https://1.bp.blogspot.com/-KcgSvjOq-SU/YSWUHcoGqrI/AAAAAAABfW0/aPcOSy9XO34Ixr-sD07IIxtQCC4yH9Q1QCNcBGAsYHQ/s180-c/food_kakuni_manju.png',
      price: 1000 + index * 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Color(0xFFFD4701),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        ),
      ),
      body: Column(
        children: [
          // カテゴリーメニュー
          Container(
            height: 56.0,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _menuButton(context, 'おすすめ', MenuCategoryPage('おすすめ')),
                _menuButton(context, '牛肉', MenuCategoryPage('牛肉')),
                _menuButton(context, '豚肉・鶏肉', MenuCategoryPage('豚肉・鶏肉')),
                _menuButton(context, 'ホルモン', MenuCategoryPage('ホルモン')),
                _menuButton(context, 'ドリンク', MenuCategoryPage('ドリンク')),
              ],
            ),
          ),
          // 商品リスト
          Expanded(
            child: ProductGrid(sampleProducts),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingCartPage()),
          );
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Color(0xFFFD4701),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Text(title),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Color(0xFFFD4701),
      ),
    );
  }
}


class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ショッピングカート'),
        backgroundColor: Color(0xFFFD4701),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<OrderModel>(
            builder: (context, order, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '注文内容:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (order.orderHistory.isNotEmpty) // orderHistoryが空でない場合のみ表示
                    for (int i = 0; i < order.orderHistory.length; i++)
                      ListTile(
                        title: Text(order.orderHistory[i]),
                        subtitle: Text(
                          '金額: ${order.orderPrices[i]}円',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  SizedBox(height: 20),
                  Text(
                    '合計金額: ${order.totalAmount}円',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 注文を確定し、お会計ページに保存
                      Provider.of<OrderModel>(context, listen: false)
                          .saveOrder();
                      // ショッピングカートをクリア
                      Provider.of<OrderModel>(context, listen: false)
                          .clearOrder();
                      // スタートページに遷移
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(Navigator.defaultRouteName),
                      );
                    },
                    child: Text('確定し注文する'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お会計'),
        backgroundColor: Color(0xFF018035),
      ),
      body: Consumer<OrderModel>(
        builder: (context, order, child) {
          int totalConfirmedAmount =
          order.confirmedPrices.fold(0, (prev, element) => prev + element);
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.confirmedOrders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(order.confirmedOrders[index]),
                      subtitle: Text('金額: ${order.confirmedPrices[index]}円'),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  '合計金額: $totalConfirmedAmount円',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // ここに会計処理を追加することができます
                  },
                  child: Text('確定して会計する'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class MenuItem {
  final String name;
  final int price;
  final String imageUrl;

  MenuItem({required this.name, required this.price, required this.imageUrl});
}