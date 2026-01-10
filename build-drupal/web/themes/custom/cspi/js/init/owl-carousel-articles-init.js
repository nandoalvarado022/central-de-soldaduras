(function ($, Drupal, drupalSettings, once) {
  Drupal.behaviors.mtOwlCarouselArticles = {
    attach: function (context, settings) {
      console.log('mtOwlCarouselArticles attach called');
      once('mtOwlCarouselArticlesInit', ".mt-carousel-articles", context).forEach(function (item) {
        console.log('Initializing owl carousel on element:', item);
        var autoplayValue = drupalSettings.cspi.owlCarouselArticlesInit.owlArticlesAutoPlay;
        var autoplayTimeoutValue = drupalSettings.cspi.owlCarouselArticlesInit.owlArticlesEffectTime;

        console.log('autoplayValue:', autoplayValue, 'autoplayTimeoutValue:', autoplayTimeoutValue);

        // Convert 1/0 to true/false if needed
        if (autoplayValue == 1 || autoplayValue === true) {
          autoplayValue = true;
        } else {
          autoplayValue = false;
        }

        console.log('Final autoplayValue:', autoplayValue);

        $(item).owlCarousel({
          items: 2,
          responsive: {
            0: {
              items: 1,
            },
            480: {
              items: 1,
            },
            768: {
              items: 2,
            },
            992: {
              items: 2,
            },
            1200: {
              items: 2,
            },
            1680: {
              items: 2,
            }
          },
          autoplay: autoplayValue,
          autoplayTimeout: autoplayTimeoutValue,
          nav: false,
          dots: false,
          loop: true,
          navText: false
        });

        console.log('Owl carousel initialized');
      });
    }
  };
})(jQuery, Drupal, drupalSettings, once);
