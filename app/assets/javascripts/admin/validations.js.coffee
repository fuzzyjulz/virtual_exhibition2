$ ->
  "use strict"

  $("#inline-validate").validate
    addClassRules:
      required: "required"
      email:
        required: true
        email: true

      date:
        required: true
        date: true

      url:
        required: true
        url: true
      youtube_id:
        minlength: 8
        maxlength: 13
      password_check:
        required: true
        minlength: 5

      confirm_password_check:
        required: true
        minlength: 5
        equalTo: "#password"

      agree: "required"
      minsize:
        required: true
        minlength: 3

      maxsize:
        required: true
        maxlength: 6

      minNum:
        required: true
        min: 3

      maxNum:
        required: true
        max: 16

    errorClass: "help-block col-lg-6"
    errorElement: "span"
    highlight: (element, errorClass, validClass) ->
      $(element).parents(".form-group").removeClass("has-success").addClass "has-error"

    unhighlight: (element, errorClass, validClass) ->
      $(element).parents(".form-group").removeClass("has-error").addClass "has-success"