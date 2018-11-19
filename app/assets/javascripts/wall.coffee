jQuery ->
  $('table#wall').DataTable
    iDisplayLength: 25
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('table#wall').data('source')
    asStripeClasses: [ ]
    columns: [
      { data: "body" },
    ]
    order: [[ 0, "desc" ]]
    language:
      url: '/i18n/dataTables.russian.json'
