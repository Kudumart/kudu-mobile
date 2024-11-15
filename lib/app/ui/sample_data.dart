import 'package:kudu/app/data/models/advert_banner.dart';

import '../data/models/enums.dart';
import '../data/models/product.dart';
import 'images.dart';

const List<Product> sampleProducts = [
  Product(
      usageStatus: UsageStatus.brandNew,
      price: 118,
      location: "Lagos, Ikeja",
      imagesUrl: [UiImage.productShoe],
      sellerPhoneNumber: "+2347065872509",
      description:
          "Experience style and comfort with our Men's Palm Leather Sandals. Featuring premium leather for a luxurious look and feel, these sandals are designed for both durability and ease. ",
      name: "Men's Palm Sandals Leather Shoes"),
  Product(
      usageStatus: UsageStatus.brandNew,
      price: 118,
      location: "Lagos, Ikeja",
      imagesUrl: [UiImage.productTrainers],
      sellerPhoneNumber: "+2347065872509",
      name: "Men's Casual Shoes Big Size 39-47"),
  Product(
      usageStatus: UsageStatus.used,
      price: 45,
      location: "Lagos, Ikeja",
      imagesUrl: [UiImage.productClothes],
      sellerPhoneNumber: "+2347065872509",
      name: "Men's Up and Down Casual Wear"),
  Product(
      usageStatus: UsageStatus.brandNew,
      price: 2500,
      location: "Lagos, Ikeja",
      imagesUrl: [UiImage.productWatch],
      sellerPhoneNumber: "+2347065872509",
      name: "Calithe 1.2 Dial, 6 inch Diameter Wrist Watch"),
];

final List<Product> sampleSimilarProducts = [
  const Product(
      name: "iPhone 13 Pro Max",
      rating: 4,
      usageStatus: UsageStatus.brandNew,
      price: 845000,
      location: "Ikeja, Lagos",
      imagesUrl: [UiImage.similarProduct1],
      currencySymbol: "₦"),
  const Product(
      name: "iPhone 13 Pro Max",
      rating: 3,
      usageStatus: UsageStatus.brandNew,
      price: 845000,
      location: "Ikeja, Lagos",
      imagesUrl: [UiImage.similarProduct2],
      currencySymbol: "₦"),
];

const sampleAdvertBanner = AdvertBanner(url: UiImage.trendingBanner);
