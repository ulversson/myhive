<template>
  <div class='users-mlc' style='font-size: 16px'>
    <a class='badge badge-pill badge-secondary text-white' v-for='user in $attrs.data.users' :key='user'>
      &nbsp;{{user}}&nbsp;
    </a>
  </div>
</template>
<script>
export default {
  props: ['row']
}
</script>