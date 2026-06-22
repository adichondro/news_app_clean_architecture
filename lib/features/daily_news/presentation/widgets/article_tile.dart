import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

class ArticleTile extends StatelessWidget {
  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onArticleTilePressed;
  final void Function(ArticleEntity article)? onArticleRemove;

  const ArticleTile({
    super.key,
    required this.article,
    this.onArticleTilePressed,
    this.isRemovable = false,
    this.onArticleRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onArticleTilePressed?.call(article!),
      child: Container(
        padding: const EdgeInsetsDirectional.only(
          start: 14,
          end: 14,
          bottom: 14,
        ),
        height: MediaQuery.of(context).size.width / 2.2,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(),
            _buildRemovableArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: article!.urlToImage!,
      imageBuilder: (context, imageProvider) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.08),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, progress) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.08),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.08),
            ),
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article!.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Butler',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(article!.description ?? '', maxLines: 2),
              ),
            ),

            Row(
              children: [
                const Icon(Icons.timeline_outlined, size: 16),
                const SizedBox(width: 4),
                Text(
                  article!.publishedAt!,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea() {
    return isRemovable!
        ? GestureDetector(
            onTap: () {
              onArticleRemove?.call(article!);
            },
            child: Container(
              margin: EdgeInsets.only(left: 4),
              padding: EdgeInsets.symmetric(horizontal: 4),
              color: Colors.red,
              height: double.maxFinite,
              child: Icon(Icons.delete_outline, color: Colors.white),
            ),
          )
        : const SizedBox();
  }
}
