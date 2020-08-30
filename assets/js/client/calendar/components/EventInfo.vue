<template>
  <modal
    name="event-info"
    :scrollable="true"
    :adaptive="true" 
    @before-open="beforeOpen"
    height="auto"
    width="400"
    :reset="false">
    <div class="epanel epanel-primary event-primary nopadding"
      :style="`background-color: ${eventObj.extendedProps.calColor} !important`">
      <div class="epanel-heading pl-4 pt-2">
        <h2><a href="#">{{eventObj.title}}</a></h2></div>
        <div class="epanel-body">
          <div class="row nopadding">
            <div class="col-sm-6 nopadding">
              <time class="start text-white"
                :class="randomColor()">
                Start <span class="day text-white">{{ startDate().getDate() }}</span>
                <span class="text-white month">{{ startMonth() }}&nbsp;{{startHour()}}</span>
                  <span class="text-white year">2016</span>
              </time>
            </div>
            <div class="col-sm-6 nopadding text-white"
              style='color: #fff !important'>
              <time class="end text-white"
              :class="randomColor()">
                End <span class="day text-white">{{ endDate().getDate() }}</span>
                <span class="month text-white">{{ endMonth() }}&nbsp;{{endHour()}}</span>
                <span class="year text-white">2016</span>
              </time>
            </div>
          </div>
        </div>
      <div class="epanel-footer epanel-primary pl-4 pt-2">
        {{eventObj.extendedProps.description}}
      </div>
      <div class='epanel-primary buttons pull-right p-3' 
        style='float: right;text-align: right; width: 100%'>
          <a class='btn btn-warning btn-sm'
            @click="editEvent()">
            <i class='fas fa-edit'></i>&nbsp;
          </a>
          <a class='btn btn-danger btn-sm'
            @click="deleteEvent()">
            <i class='fas fa-trash-alt'></i>&nbsp;
          </a>
          <a class='btn btn-secondary btn-sm' 
            @click="hideModal()">
            <i class='fas fa-ban'></i>&nbsp;
          </a>
      </div>
    </div>
  </modal>
</template>
<script>
export default {
  props: ['eventObj'],
  created() {
    console.log(this.eventObj)
  },
  methods: {
    beforeOpen(event) {
      if (event && event.params && (event.params.eventObj)) {
        this.eventObj = event.params.event
      }
    },
    editEvent(){
      let newEvent = this.$parent.$refs.newEvent
      newEvent.startDate = this.eventObj.startStr
      newEvent.endDate = this.eventObj.endStr
      newEvent.name = this.eventObj.title
      newEvent.allDay = this.eventObj.allDay
      newEvent.description = this.eventObj.extendedProps.description
      newEvent.currentEvent = this.eventObj.extendedProps.dbId
      newEvent.edit = true
      this.$modal.hide('event-info')
      this.$modal.show('new-cal-event')
    },
    deleteEvent() {
      UI.runConfirmedAction(
        'fas fa-trash-alt',
        'DELETE',
        'Remove this event',
        'This action cannot be reversed',
        `/api/v1/calendar_events/${this.eventObj.extendedProps.dbId}`,
        () => {
          window.location.reload(true)
        }
      )
    },
    endDate() {
      debugger
      return moment.utc(this.eventObj.endStr).tz('Europe/London').toDate()
    },
    startDate() {
      return moment.utc(this.eventObj.startStr).tz('Europe/London').toDate()
    },
    startMonth() {
      return moment.utc(this.eventObj.startStr).tz('Europe/London').format('MMM')
    },
    endMonth() {
      return moment.utc(this.eventObj.endStr).tz('Europe/London').format('MMM')
    },
    startHour() {
      return moment.utc(this.eventObj.startStr).tz('Europe/London').format('HH:mm')
    },
    endHour() {
      return moment.utc(this.eventObj.endStr).tz('Europe/London').format('HH:mm')
    },
    randomColor() {
      return this.colors[Math.floor(Math.random() * this.colors.length)]
    },
    hideModal() {
      this.$modal.hide('event-info')
    }
  },
  data() {
    return {
      colors: [
        'pink', 'purple', 'dkblue','blue_green','blue_violet',
        'brown', 'crimson','deep_pink', 'forest_green','fuchsia',
        'gray','green','hotpink', 'lemon', 'light_blue','light_red',
        'lime', 'lime_green', 'magenta','maroon','midnight',
        'olive','orange','orange_red','orange_yellow','peach','pink',
        'purple','red','red_orange','salmon','tan','teal','violet',
        'violet_blue','yellow','yellow_green','yellow_orange'
      ]
    }
  }
}
</script>