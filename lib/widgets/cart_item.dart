import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Jestes pewien?'),
            content:
                const Text('Czy na pewno chcesz usunąć ten produkt z koszyka?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Tak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Nie'),
              )
            ],
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                child: Text(
                  '${price}zł',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            title: Text(
              title,
            ),
            subtitle: Text('W sumie: ${price * quantity}zł'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
