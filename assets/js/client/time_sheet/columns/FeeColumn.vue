<template>
  <toggle-button @change="onChangeEventHandler($attrs.data.id, $event)"
    :font-size="15"
    :labels="{checked: 'YES',
     unchecked: 'NO'}"
    :width="55"
    :value='Boolean($attrs.data.note_issued)'
    :color="{checked: '#02BC77', 
      unchecked: '#d9534f', 
      disabled: '#CCCCCC'
    }"
    :height='20'/>
</template>
<script>
export default {
  mounted(){
  },
  methods: {
    onChangeEventHandler(eventId, event) {
      let updateData = {
        "_method" : "PUT",
        "id" : eventId,
        "note_issued": event.value
      }
      $.ajax({
        type: "PUT",
        url: `/api/v1/time_sheet/${eventId}`,
        data: updateData,
        dataType: "json"
      })
    }
  }
}
</script>