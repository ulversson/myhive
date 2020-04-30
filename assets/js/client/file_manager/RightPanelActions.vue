<template>
  <div class="cui-github-explore-sort-right">
    <div class="cui-github-explore-sort-option">
      <div class="btn-group">
        <button type="button" class="btn btn-sm btn-default">
          <i class="fas fa-folder-plus"></i>
          &nbsp;Create new
        </button>
        <button type="button" class="btn btn-sm">
          <i class="fas fa-search"></i>
          &nbsp;Search
        </button>
        <div class='cui-github-explore-sort-option'>
          <button type="button" class="btn btn-sm dropdown-toggle"
            data-toggle="dropdown" aria-expanded="false">
            Order
          </button>
          <ul class="dropdown-menu" aria-labelledby="" role="menu">
            <a class="dropdown-item" href="javascript: void(0)">Name A-Z</a>
            <a class="dropdown-item" href="javascript: void(0)">Name Z-A</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="javascript: void(0)">Date A-Z</a>
            <a class="dropdown-item" href="javascript: void(0)">Date Z-A</a>
          </ul>
        </div>
      </div>
    </div>
    <div class="dropdown cui-github-explore-sort-option">
      <button type="button"
        class="btn btn-sm dropdown-toggle"
        data-toggle="dropdown"
        aria-expanded="false">
        Bulk
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <a class="dropdown-item" href="javascript: void(0)">Action</a>
        <a class="dropdown-item" href="javascript: void(0)">Another action</a>
        <a class="dropdown-item" href="javascript: void(0)">Something else here</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="javascript: void(0)">Separated link</a>
      </ul>
    </div>
  </div>
</template>