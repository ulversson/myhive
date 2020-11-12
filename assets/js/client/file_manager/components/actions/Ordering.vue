<template>
  <div class="cui-github-explore-sort-option">
    <button type="button"
      class="btn dropdown-toggle"
      data-toggle="dropdown"
      aria-expanded="false">
      Order
    </button>
    <ul class="dropdown-menu" aria-labelledby="" role="menu">
      <a class="dropdown-item" href="javascript: void(0)"
        :class="isActive('name', 'asc') ? 'active' : ''"
        @click="setOrder('name', 'asc')">
        <i class="fas fa-sort-alpha-down"></i>
        &nbsp;Name A-Z
      </a>
      <a class="dropdown-item" href="javascript: void(0)"
        :class="isActive('name', 'desc') ? 'active' : ''"
        @click="setOrder('name', 'desc')">
        <i class="fas fa-sort-alpha-up-alt"></i>
        &nbsp;Name Z-A
      </a>
      <div class="dropdown-divider"></div>
      <a class="dropdown-item" href="javascript: void(0)"
        :class="isActive('date', 'asc') ? 'active' : ''"
        @click="setOrder('date', 'asc')">
        <i class="fas fa-sort-numeric-down"></i>
        &nbsp;Date asc
      </a>
      <a class="dropdown-item" href="javascript: void(0)"
        :class="isActive('date', 'desc') ? 'active' : ''"
        @click="setOrder('date', 'desc')">
        <i class="fas fa-sort-numeric-up-alt"></i>
        &nbsp;Date desc
      </a>
    </ul>
  </div>
</template>
<script>
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ["currentFolderId"],
  mixins: [currentFolder],
  methods: {
    isActive(column, direction) {
      return (
        this.$store.state.column === column &&
        this.$store.state.order === direction
      );
    },
    setOrder(column, direction) {
      this.$store.commit("setColumn", column)
      this.$store.commit("setOrder", direction)
      this.managerComponent.setCurrentFolder(this.currentFolderId)
    },
  },
}
</script>
