
jQuery(document).ready(function()
{

  jQuery('#submit').live('click',function(){
    var valid = true;
    jQuery('[data-validate]:input:visible').each(function() {
      var settings = window[this.form.id];
      if (!jQuery(this).isValid(settings.validators)) {
        valid = false
      }
    });
    if(valid){
      jQuery('#user-info').hide();
      jQuery('#referral_form').show();
    }
    return false;
  });
  
  jQuery('.sliding').click(function(){
    jQuery(this).parents('.widget_large').find('.slidecontent').slideToggle();
    return false;
  });

  jQuery('.user_status').click(function(){
    spi = jQuery(this).parents('.profile_card').find('.spinner');
    rel = this
    jQuery.ajax({
      beforeSend: function(){
        jQuery(spi).show();
      },
      complete: function(){
        jQuery(spi).hide();
      },
      url: jQuery(this).attr('href'),
      dataType: "json",
      type: 'GET',
      success: function(data){
        jQuery(rel).text(data).fadeIn("fast");
      }
    });
    return false;
  });

  jQuery('.friend_status').live('click',function(){
    rel = jQuery(this).parents('.profile_action').find('.profile');
    spi = jQuery(this).parents('.profile_action').find('.spinner');
    path = jQuery(this).attr('href');
    method = jQuery(this).attr('type');
    jQuery.ajax({
      beforeSend: function(){
        jQuery(spi).show();
      },
      complete: function(){
        jQuery(spi).hide();
      },
      url: path,
      dataType: "html",
      type: method,
      success: function(response){
        jQuery(rel).replaceWith(response)
      }
    });
    return false;
  });

  jQuery('form.poll').submit(function(){
    rel = jQuery(this).parents('.poll_text').find('form.poll');
    spi = jQuery(this).parents('.poll').find('.spinner');
    path = jQuery(this).attr('action');
    value= jQuery("form.poll input[type='radio']:checked").val();
    jQuery.ajax({
      beforeSend: function(){
        jQuery(spi).show();
      },
      complete: function(){
        jQuery(spi).hide();
      },
      url: path,
      dataType: "html",
      type: 'POST',
      data:{
        option: value
      },
      success: function(response){
        jQuery(rel).replaceWith(response)
      }
    })
    return false;
  });

  jQuery('.rsvp_event').click(function(){
    var path = jQuery(this).attr('url');
    var name = jQuery(this).attr('name');
    spi = jQuery(this).parents('.event').find('.spinner');
    var type = jQuery(this).val();
    jQuery.ajax({
      beforeSend: function(){
        jQuery(spi).show();
      },
      complete: function(){
        jQuery(spi).hide();
      },
      url: path,
      dataType: "json",
      type: "GET",
      data: {
        group: type
      },
      success: function(data){
        if(data == 'Organizer') {
          jQuery("input:radio[id='"+name+"_Attending']").attr('checked', true);
        }
        else{
          jQuery("input:radio[name='"+name+"']:checked").attr('checked', true);
        }
      }
    })
  });

  jQuery(".show-comments").click(function() {
    jQuery(this).parents('.commentable').find('.blog_comments').toggle();
    return false;
  });

  jQuery(".add-comment").click(function() {
    jQuery(this).parents('.commentable').find('.comment_form').toggle();
    return false;
  });
 
  jQuery(".delete-comment").click(function(){
    delete_link = jQuery(this);
    rel = jQuery(this).parents('.commentable').find('.show-comments');
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "json",
      type: 'DELETE',
      success: function(data){
        jQuery(delete_link).parents('.comment').fadeOut("slow");
        jQuery(rel).text(data).fadeIn("fast");
      }
    });
    return false;
  });

  jQuery(".delete_feed").click(function(){
    rel = jQuery(this).parents('.feed_item');
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "json",
      type: 'DELETE',
      success: function(){
        jQuery(rel).fadeOut("slow");
      }
    });
    return false;
  });

  jQuery(".delete_titles").live('click',function(){
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "html",
      type: 'DELETE',
      success: function(response){
        jQuery('#titles').html(response);
      }
    });
    return false;
  });

  jQuery(".delete_house").live('click',function(){
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "html",
      type: 'DELETE',
      success: function(response){
        jQuery('#houses').html(response);
      }
    });
    return false;
  });

  jQuery(".add_title").live('click',function(){
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "html",
      type: 'GET',
      success: function(response){
        jQuery("#title").html(response)
      }
    });
    return false;
  });

  jQuery(".add_house").live('click',function(){
    jQuery.ajax({
      url: jQuery(this).attr('href'),
      dataType: "html",
      type: 'GET',
      success: function(response){
        jQuery("#house_name").html(response)
      }
    });
    return false;
  });

  jQuery(".comment-form-cancel").click(function(){
    jQuery(this).parents('.comment_form').hide();
    return false;
  });

  jQuery(".status-form-cancel").click(function(){
    jQuery('#status_form').hide();
    jQuery('#status_show').show();
    return false;
  });

  jQuery("#status_show").click(function(){
    jQuery('#status_form').show();
    jQuery('#status_show').hide();
    return false;
  });

  jQuery('.datebalks').datepicker({
    dateFormat:'dd M yy',
    showOn: "both",
    buttonImage: "/images/calendar.gif",
    buttonImageOnly: true,
    yearRange: "-50:+0",
    changeMonth: true,
    changeYear: true,
    nextText: "",
    prevText: ""

  });
  jQuery('.datetime').datetimepicker({
    duration: '',
    showTime: true,
    constrainInput: false,
    stepMinutes: 1,
    stepHours: 1,
    altTimeField: '',
    time24h: false
  });
 

  jQuery("a.select_all").click(function(){
    jQuery("input[type='checkbox']:not([disabled='disabled'])").attr('checked', true);
  });

  jQuery('form[data-remote]').bind("ajax:before", function(){
    for (instance in CKEDITOR.instances){
      CKEDITOR.instances[instance].updateElement();
    }
  });

  jQuery("#status").click(function(){
    jQuery("#status").hide();
    jQuery("#in-place-edit").show();
  });

  jQuery(".cursor").hover(
    function(){
      jQuery(this).css('background-color', '#FFF380')
    },
    function(){
      jQuery(this).css('background-color', 'transparent')
    });

  jQuery("#student_check_year").change(function() {
    year = this.value
    jQuery.ajax({
      url: "/student_checks/view_year_students",
      dataType: "json",
      type: "GET",
      data: {
        group: year
      },
      success: function(data){
        jQuery('#student_check_profile_id').find('option').remove() ;
        var options = '' ;
        var year = data
        for (var i = 0; i < year.length; i++) {
          if (i==0)
          {
            options += '<option selected value="' + year[i][1] + '">' + year[i][0] + '</option>';
          }
          else
          {
            options += '<option value="' + year[i][1] + '">' + year[i][0] + '</option>';
          }
        }
        jQuery('#student_check_profile_id').html(options);   // populate select box with array
      }
    });
  })

  jQuery(function() {
    jQuery('#cropbox').Jcrop({
      onChange: update_crop,
      onSelect: update_crop,
      setSelect: [0, 0, 500, 500],
      aspectRatio: 1
    })
  });

  function update_crop(coords) {
    jQuery('#photo_crop_x').val(coords.x);
    jQuery('#photo_crop_y').val(coords.y);
    jQuery('#photo_crop_w').val(coords.w);
    jQuery('#photo_crop_h').val(coords.h);
  }
});

function remove_fields(link) {
  jQuery(link).prev("input[type=hidden]").val("1");
  jQuery(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  jQuery(link).parent().before(content.replace(regexp, new_id));
}

jQuery('#search_q').live('focus.search_query_field', function(){
  if(jQuery(this).val()=='Search for Friends'){
    jQuery(this).val('');
  }
});

jQuery('#search_q').live('blur.search_query_field', function(){
  if(jQuery(this).val()==''){
    jQuery(this).val('Search for Friends');
  }
});

jQuery('#search_all').live('focus.search_query_field', function(){
  if(jQuery(this).val()=='Search'){
    jQuery(this).val('');
  }
});

jQuery('#search_all').live('blur.search_query_field', function(){
  if(jQuery(this).val()==''){
    jQuery(this).val('Search');
  }
});

// To Display twitter updates
function twitter_blog(user){
  new TWTR.Widget({
    version: 2,
    type: 'profile',
    rpp: 4,
    interval: 3000,
    width: 'auto',
    height: 300,
    id: 'twtr-widget',
    theme: {
      shell: {
        background: '#d9c1a7',
        color: '#141214'
      },
      tweets: {
        background: '#ffffff',
        color: '#5c573a',
        links: '#417fb5'
      }
    },
    features: {
      scrollbar: false,
      loop: true,
      live: true,
      hashtags: true,
      timestamp: true,
      avatars: false,
      behavior: 'default'
    }
  }).render().setUser(user).start();
}

function gallery(){
  jQuery('div.navigation').css({
    'width' : '300px',
    'float' : 'left'
  });
  jQuery('div.content').css('display', 'block');
  jQuery('.content').galleriffic('#thumbs', {
    delay:                  2000,
    numThumbs:              12,
    preloadAhead:           0,
    enableTopPager:         true,
    enableBottomPager:      false,
    imageContainerSel:      '#slideshow',
    controlsContainerSel:   '#controls',
    loadingContainerSel:    '#loading',
    captionContainerSel:    '#caption',
    playLinkText:           'Play Slideshow',
    pauseLinkText:          'Pause Slideshow',
    prevLinkText:           'Previous',
    nextLinkText:           'Next',
    onPageTransitionIn: function() {
      jQuery('#thumbs ul.thumbs').fadeIn('fast');
      jQuery('#thumbs ul.thumbs > li:visible').each(function(){
        if(jQuery(this).children("a:has('img')").length == 1){
        }else{
          jQuery(this).children('a').append("<img src = " + jQuery(this).attr('title') + "></img>");
          jQuery(this).removeAttr("title");
        }
      });
    },
    onPageTransitionOut: function(callback) {
      jQuery('#thumbs ul.thumbs').fadeOut('slow', callback);
    }
  });
}

function show_blurb_panel(){
  jQuery('.slideshow').cycle({
    fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
  });
}

function show_gallery(){
  jQuery('#mycarousel').jcarousel({
    size:jQuery("ul#mycarousel > li").length,
    vertical: true
  });
}
function show_album_photo_uploader(){
  jQuery('#file_upload').fileUploadUIX({
    // Wait for user interaction before starting uploads:
    autoUpload: false,
    // Upload bigger files in chunks of 10 MB (remove or set to null to disable):
    maxChunkSize: 10000000,
    // Request uploaded filesize prior upload and upload remaining bytes:
    continueAbortedUploads: true,
    // Open download dialogs via iframes, to prevent aborting current uploads:
    forceIframeDownload: true
  });
}