<template>
  <div id='cal-tabs' class='mt-5'>
    <ul class="nav nav-tabs mb-4" role="tablist">
    <li class="nav-item">
      <a class="nav-link active"
        href="#calendar" data-toggle="tab" data-target="#calendar" role="tab">
        <i class="fas fa-calendar-day"></i>
        Your Calendar
      </a>
    </li>
     <li class="nav-item">
      <a class="nav-link" href="#others" 
        v-if="isAdmin"
        data-toggle="tab" data-target="#others" role="tab">
        <i class="fas fa-user-friends"></i>
        Others
      </a>
    </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active" id="calendar">
        <Calendar ref="cal" />
      </div>
      <div class="tab-pane" id="others" v-if="isAdmin">
        <OtherCalendar ref="other-cal" />
      </div>
    </div>
  </div>
</template>
<script>
import Calendar from './Calendar.vue'
import OtherCalendar from './OtherCalendar.vue'
import shared from '../../medico_legal_cases/mixins/shared'
export default {
  mixins: [shared],
  components: {
    Calendar, OtherCalendar
  },
}
</script>