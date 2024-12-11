import 'package:kudu/app/models/advert_banner.dart';

import '../models/auction.dart';
import '../models/enums_and_extensions.dart';
import '../models/product.dart';
import 'images.dart';

const List<Product> sampleProducts = [
  Product(
      condition: ProductCondition.brandNew,
      price: 118,
      location: "Lagos, Ikeja",
      imagesUrl: [AppUiImage.productShoe],
      sellerPhoneNumber: "+2347065872509",
      description:
          "Experience style and comfort with our Men's Palm Leather Sandals. Featuring premium leather for a luxurious look and feel, these sandals are designed for both durability and ease. ",
      name: "Men's Palm Sandals Leather Shoes"),
  Product(
      condition: ProductCondition.brandNew,
      price: 118,
      location: "Lagos, Ikeja",
      imagesUrl: [AppUiImage.productTrainers],
      sellerPhoneNumber: "+2347065872509",
      name: "Men's Casual Shoes Big Size 39-47"),
  Product(
      condition: ProductCondition.used,
      price: 45,
      location: "Lagos, Ikeja",
      imagesUrl: [AppUiImage.productClothes],
      sellerPhoneNumber: "+2347065872509",
      name: "Men's Up and Down Casual Wear"),
  Product(
      condition: ProductCondition.brandNew,
      price: 2500,
      location: "Lagos, Ikeja",
      imagesUrl: [AppUiImage.productWatch],
      sellerPhoneNumber: "+2347065872509",
      name: "Calithe 1.2 Dial, 6 inch Diameter Wrist Watch"),
];

final List<Product> sampleSimilarProducts = [
  const Product(
      name: "iPhone 13 Pro Max",
      rating: 4,
      condition: ProductCondition.brandNew,
      price: 845000,
      location: "Ikeja, Lagos",
      imagesUrl: [AppUiImage.similarProduct1],
      currencySymbol: "₦"),
  const Product(
      name: "iPhone 13 Pro Max",
      rating: 3,
      condition: ProductCondition.brandNew,
      price: 845000,
      location: "Ikeja, Lagos",
      imagesUrl: [AppUiImage.similarProduct2],
      currencySymbol: "₦"),
];

const sampleAdvertBanner = AdvertBanner(url: AppUiImage.trendingBanner);

final Auction sampleAuction = Auction(
  id: "id",
  storeID: "storeID",
  categoryID: "categoryID",
  name: "2014 Audi A4 All road",
  condition: ProductCondition.used,
  description: "This is a sample description",
  specification: const {
    "VIN": "1WEIONS12",
    "Odometer": "223, 264 mi (ACTUAL)",
    "Primary Damages": "Minor Dent | Scratches",
    "Cylinders": "4",
    "Engine Type": "2.0L 4",
    "Transmission": "Automatic",
    'Drive': "All Wheel Drive",
    "Vehicle Type": "Automobile",
    "Fuel": "Flexible Fuel",
    "Keys": "YES",
    "Highlight": "Run and Drive"
  },
  minimumSalePrice: 45000,  
  minimumBidPrice: 50000,
  bidIncrement: 5,
  maxBidPerUser: 3,
  participantsInterestFee: 50,
  additionalImages: const [],
  starts: DateTime.now(),
  ends: DateTime.now().add(const Duration(days: 5)),
  image: AppUiImage.auctionCar,
  createdOn: DateTime.now().subtract(const Duration(days: 5)),
  location: "15 Awolowo Way, Ikeja, Lagos, Nigeria",
  currentHighestBid: 75450,
);
