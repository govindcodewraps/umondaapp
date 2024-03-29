import 'dart:async';

import 'package:flutter/material.dart';

import '../../repositories/category_repository.dart';
import '../../repositories/flash_deal_repository.dart';
import '../../repositories/product_repository.dart';
import '../../repositories/sliders_repository.dart';
import 'Allnewads_Screen.dart';



class AllHomePresenter extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int current_slider = 0;
  ScrollController allProductScrollController;
  ScrollController featuredCategoryScrollController;
  ScrollController mainScrollController = ScrollController();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var carouselImageList = [];
  var bannerOneImageList = [];
  var bannerTwoImageList = [];
  var featuredCategoryList = [];

  bool isCategoryInitial = true;

  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isBannerTwoInitial = true;

  var featuredProductList = [];
  bool isFeaturedProductInitial = true;
  int totalFeaturedProductData = 0;
  int featuredProductPage = 1;
  bool showFeaturedLoadingContainer = false;

  bool isTodayDeal = false;
  bool isFlashDeal = false;

  var allProductList = [];
  bool isAllProductInitial = true;
  int totalAllProductData = 0;
  //int allProductPage = 1;
  bool showAllLoadingContainer = false;
  int cartCount = 0;

  fetchAll() {
    print("All product list count:: ${allProductPage}");
    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchAllProducts();
    fetchTodayDealData();
    fetchFlashDealData();
  }

  fetchTodayDealData() async {
    var deal = await ProductRepository().getTodaysDealProducts();
    print(deal.products.length);
    if (deal.success && deal.products.isNotEmpty) {
      isTodayDeal = true;
      notifyListeners();
    }
  }

  fetchFlashDealData() async {
    var deal = await FlashDealRepository().getFlashDeals();

    if (deal.success && deal.flashDeals.isNotEmpty) {
      isFlashDeal = true;
      notifyListeners();
    }
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      carouselImageList.add(slider.photo);
    });
    isCarouselInitial = false;
    notifyListeners();
  }

  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneResponse.sliders.forEach((slider) {
      bannerOneImageList.add(slider.photo);
    });
    isBannerOneInitial = false;
    notifyListeners();
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoResponse.sliders.forEach((slider) {
      bannerTwoImageList.add(slider.photo);
    });
    isBannerTwoInitial = false;
    notifyListeners();
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    featuredCategoryList.addAll(categoryResponse.categories);
    isCategoryInitial = false;
    print("home_presenter.dart, fetchFeaturedCategories(), response : $featuredCategoryList");
    notifyListeners();
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: featuredProductPage,
    );
    featuredProductPage++;
    featuredProductList.addAll(productResponse.products);
    isFeaturedProductInitial = false;
    totalFeaturedProductData = productResponse.meta.total;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  fetchAllProducts() async {
    var productResponse =
    await ProductRepository().getFilteredProducts(page: allProductPage);

    allProductList.addAll(productResponse.products);
    isAllProductInitial = false;
    totalAllProductData = productResponse.meta.total;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  reset() {
    carouselImageList.clear();
    bannerOneImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();

    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    cartCount = 0;

    resetFeaturedProductList();
    resetAllProductList();
  }

  Future<void> onRefresh() async {
    print("All product list count::on ${allProductPage}");
    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    featuredProductList.clear();
    isFeaturedProductInitial = true;
    totalFeaturedProductData = 0;
    featuredProductPage = 1;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  resetAllProductList() {
    allProductList.clear();
    isAllProductInitial = true;
    totalAllProductData = 0;
    allProductPage;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  // mainScrollListener() {
  //   mainScrollController.addListener(() {
  //     //print("position: " + xcrollController.position.pixels.toString());
  //     //print("max: " + xcrollController.position.maxScrollExtent.toString());
  //
  //     if (mainScrollController.position.pixels ==
  //         mainScrollController.position.maxScrollExtent) {
  //       allProductPage++;
  //       print("Product page count : ${allProductPage}");
  //
  //       showAllLoadingContainer = true;
  //       fetchAllProducts();
  //       //print("Product page count : ${allProductPage}");
  //     }
  //   });
  // }


  mainScrollListener() {
    mainScrollController.addListener(() {
      if (mainScrollController.position.pixels == mainScrollController.position.maxScrollExtent) {
        // Scrolling down, load next page
        allProductPage++;
        print("Product page count : ${allProductPage}");
        showAllLoadingContainer = true;
        fetchAllProducts();
      } else if (mainScrollController.position.pixels == mainScrollController.position.minScrollExtent) {
        // Scrolling up, load previous page
        if (allProductPage > 1) {
          allProductPage--;
          print("Product page count : ${allProductPage}");
          showAllLoadingContainer = true;
          fetchAllProducts();
        }
      }
    });
  }



  initPiratedAnimation(vnc) {
    pirated_logo_controller =
        AnimationController(vsync: vnc, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  // incrementFeaturedProductPage(){
  //   featuredProductPage++;
  //   notifyListeners();
  //
  // }

  incrementCurrentSlider(index) {
    current_slider = index;
    notifyListeners();
  }


  void dispose() {
    pirated_logo_controller.dispose();
    notifyListeners();
  }
}