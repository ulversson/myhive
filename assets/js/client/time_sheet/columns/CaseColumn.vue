<template>
  <div class="media align-items-center case-folder" style="cursor: pointer">
      <i class="d-block ui-w-40 rounded-circle fas fa-folder-open fa-2x" :class='folderColor'></i>
      <div class="media-body flex-basis-auto pl-3" style='font-size: 14px'>
      <div class="name">
        {{$attrs.data.case}}
        <i class="fas fa-cross text-default" v-if='$attrs.data.deceased'></i>
      </div>
    </div>
  </div>
</template>