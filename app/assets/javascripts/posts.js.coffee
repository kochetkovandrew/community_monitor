jQuery ->
  $('table#post_comments').DataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('table#post_comments').data('source')
    asStripeClasses: [ ]
    columns: [
      { data: "body" },
    ]
    order: [[ 0, "asc" ]]
    language:
      url: '/i18n/dataTables.russian.json'
