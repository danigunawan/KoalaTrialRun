$(document).on('ready page:change page:load turbolinks:load', function(){
  $('.comment-on-post').click(function(){
    var post_id = $(this).parent().find('input[type="checkbox"]').val();
    $('.comment-on-post').parent().find('.text-area-post').empty();
    $(this).parent().find('.text-area-post').html('<textarea name="comment_post" class="comment-post"></textarea>');
    $(this).parent().find('.text-area-post').append('<input type="hidden" name="comment_post_id" value="' + post_id + '"/>' )
  });
});
