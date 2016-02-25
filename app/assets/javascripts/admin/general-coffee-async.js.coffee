$ ->
  "use strict"
  
  $("a[href=#]").on "click", (e) ->
    e.preventDefault()

  ## Run the rich text editor
  $(".cleditor").cleditor()
  
  ## Setup date picker
  $('input.datetimepicker').datetimepicker
    useSeconds: false
    format: 'YYYY-MM-DD H:mm:ss'
  
  
  ## Setup for datatables
  ajax_loader = image_path('loader-black.gif')

  responsiveHelper = `undefined`
  breakpointDefinition =
    tablet: 1024
    phone: 480

  ## Event Dashboard Page
  tableElement = $('.dataTable')

  tableElement.dataTable({
    "sDom": "<'row'<'col-md-12'<'pull-right datatables-menu'il>>>t<'row'<'col-lg-6'f><'col-lg-6'p>>"
    "sPaginationType": "bootstrap"
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100,"All"]]
    "oLanguage":
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 100
    "bAutoWidth": false
    "sScrollX": "100%"
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElement, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()


  ## Users table
  tableElementUsers = $('#dataTableUsers')
  tableElementUsers.dataTable({
    "sDom": "<'row'<'col-md-12'<'pull-left'f>r<'pull-right datatables-menu'il>>><'row'<'col-md-12'<'pull-right'p>>>t<'row'<'col-md-12'<'pull-left'f><'pull-right datatables-menu'il>>><'row'<'col-md-12'<'pull-right'p>>>"
    "sPaginationType": "bootstrap"
    "aLengthMenu": [[10, 25, 50, 100], [10, 25, 50, 100]]
    "aoColumnDefs":[{
      "bSortable": false
      "aTargets": ["no-sort"]
    }]
    "oLanguage":
      "sProcessing": "<div class='alert alert-info' id='ajax-loader'>Processing data... <img src='" + ajax_loader + "' /></div>"
      "sLengthMenu": "_MENU_ entries per page"
      "sInfo": "Listing (_START_ to _END_) of _TOTAL_ entries"
    "iDisplayLength": 100
    "bAutoWidth": false
    "sScrollX": "100%"
    "bProcessing": true
    "bServerSide": true
    "sAjaxSource": $('#dataTableUsers').data('source')
    fnPreDrawCallback: ->
      # Initialize the responsive datatables helper once.
      responsiveHelper = new ResponsiveDatatablesHelper(tableElementUsers, breakpointDefinition) unless responsiveHelper

    fnRowCallback: (nRow) ->
      responsiveHelper.createExpandIcon nRow

    fnDrawCallback: (oSettings) ->
      responsiveHelper.respond()
  }).columnFilter()
