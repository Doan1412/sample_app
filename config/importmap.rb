# Pin npm packages by running ./bin/importmap

# config/importmap.rb

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo"
pin "@hotwired/stimulus-rails", to: "stimulus"
pin "bootstrap", to: "https://cdn.skypack.dev/bootstrap@5.1.3/dist/js/bootstrap.esm.min.js"
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"
pin "popper.js", to: "https://cdn.skypack.dev/@popperjs/core@2.10.2/dist/umd/popper.min.js"
pin_all_from "app/javascript/custom", under: "custom"
