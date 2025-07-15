import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';
import '../models/wishlist_model.dart';
import '../../home/pages/product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishlistBloc()..add(const LoadWishlistEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF3DDCFF),
          elevation: 0,
          title: const Text(
            'My Wishlist',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // Chỉ hiển thị nút Clear khi có items
            BlocBuilder<WishlistBloc, WishlistState>(
              buildWhen: (previous, current) {
                // Chỉ rebuild khi số lượng items thay đổi
                if (previous is WishlistLoaded && current is WishlistLoaded) {
                  return previous.items.length != current.items.length;
                }
                return true;
              },
              builder: (context, state) {
                if (state is WishlistLoaded && state.items.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.white),
                    onPressed: () => _showClearConfirmDialog(context),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<WishlistBloc, WishlistState>(
          // Listener để hiển thị snackbar cho các action
          listener: (context, state) {
            if (state is WishlistError) {
              _showErrorSnackBar(context, state.message);
            }
          },
          // Builder để render UI theo state
          builder: (context, state) {
            // 1. INITIAL & LOADING STATES
            if (state is WishlistInitial || state is WishlistLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3DDCFF)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading your wishlist...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // 2. ERROR STATE
            if (state is WishlistError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<WishlistBloc>().add(const LoadWishlistEvent());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3DDCFF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // 3. ACTION IN PROGRESS STATE
            if (state is WishlistActionInProgress) {
              return Stack(
                children: [
                  // Hiển thị danh sách hiện tại
                  _buildWishlistContent(context, state.items),
                  // Overlay loading
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                _getActionMessage(state.actionType),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            
            // 4. LOADED STATE
            if (state is WishlistLoaded) {
              return _buildWishlistContent(context, state.items);
            }
            
            // 5. FALLBACK
            return const Center(
              child: Text('Unknown state'),
            );
          },
        ),
      ),
    );
  }

  // Helper method để build nội dung wishlist
  Widget _buildWishlistContent(BuildContext context, List<WishlistModel> items) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add products you love to your wishlist',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<WishlistBloc>().add(const LoadWishlistEvent());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _WishlistItemCard(
            item: item,
            onRemove: () {
              // context.read<WishlistBloc>().add(
              //   RemoveFromWishlistEvent(productId: item.product.id),
              // );
            },
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => ProductDetailPage(product: item.product),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }

  // Helper methods
  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear Wishlist'),
          content: const Text('Are you sure you want to remove all items from your wishlist?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<WishlistBloc>().add(const ClearWishlistEvent());
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  String _getActionMessage(String actionType) {
    switch (actionType) {
      case 'adding':
        return 'Adding to wishlist...';
      case 'removing':
        return 'Removing from wishlist...';
      case 'clearing':
        return 'Clearing wishlist...';
      default:
        return 'Processing...';
    }
  }
}

// Widget riêng cho từng item trong wishlist
class _WishlistItemCard extends StatelessWidget {
  final WishlistModel item;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _WishlistItemCard({
    required this.item,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₫${item.product.price}',
                      style: const TextStyle(
                        color: Color(0xFF3DDCFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Added ${_formatDate(item.addedAt)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onRemove,
                    tooltip: 'Remove from wishlist',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
