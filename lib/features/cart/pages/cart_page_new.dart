import 'package:cyder_store/features/cart/pages/cart_confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load cart data when page is opened
    context.read<CartBloc>().add(LoadCartData());
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartOperationSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is CartError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              debugPrint('CartPage: current state = $state');

              if (state is CartLoaded || state is CartOperationSuccess) {
                List<CartItem> cartItems;
                
                if (state is CartLoaded) {
                  cartItems = state.cartItems;
                } else {
                  cartItems = (state as CartOperationSuccess).cartItems;
                }
                
                debugPrint('DEBUG: Cart with ${cartItems.length} items');

                if (cartItems.isEmpty) {
                  return const Center(child: Text("Your cart is empty"));
                }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final product = item.product;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₫${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.brand.isNotEmpty
                                    ? product.brand
                                    : product.description,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, color: Colors.grey[400], size: 22),
                                  const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 18),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              // Decrease quantity
                                              if (item.id != null) {
                                                context.read<CartBloc>().add(
                                                  UpdateCartQuantity(item.id!, item.quantity - 1)
                                                );
                                              }
                                            } else {
                                              // Remove item if quantity is 1
                                              if (item.id != null) {
                                                context.read<CartBloc>().add(
                                                  RemoveFromCart(item.id!)
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 18),
                                          onPressed: () {
                                            // Increase quantity
                                            if (item.id != null) {
                                              context.read<CartBloc>().add(
                                                UpdateCartQuantity(item.id!, item.quantity + 1)
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        ),
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if ((state is CartLoaded && state.cartItems.isNotEmpty) ||
              (state is CartOperationSuccess && state.cartItems.isNotEmpty)) {
            return FloatingActionButton.extended(
              onPressed: () {
                final cartBloc = BlocProvider.of<CartBloc>(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: cartBloc,
                      child: const CartConfirmPage(),
                    ),
                  ),
                );
              },
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              label: const Text(
                'Proceed',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
