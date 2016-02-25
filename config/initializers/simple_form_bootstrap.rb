# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline text-danger' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  config.wrappers :horizontal, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'col-lg-8' do |ba|
      ba.use :input
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      ba.use :error, wrap_with: { tag: 'span', class: 'help-inline text-danger' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: "input-group", error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'input-prepend' do |prepend|
      prepend.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline text-danger' }
  end

  config.wrappers :append, tag: 'div', class: "input-group", error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'input-append' do |append|
      append.use :input
    end
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline text-danger' }
  end

  config.wrappers :group, tag: 'div', class: "form-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

  config.wrappers :checkbox, tag: 'div', class: "checkbox", error_class: "has-error" do |b|
    b.use :html5
    b.wrapper tag: :label do |ba|
      ba.use :input
      ba.use :label_text
    end
    b.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    b.use :error, wrap_with: { tag: :span, class: "help-block text-danger" }
  end

  config.wrappers :radio_buttons, tag: 'div', class: "form-group", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, { class: "control-label col-lg-4" }
    b.wrapper :tag => 'div', class: "col-lg-8" do |ba|
      ba.wrapper :tag => 'div', class: 'radio' do |label|
        label.wrapper :tag => 'label' do |radio_container|
          radio_container.wrapper :tag => 'div', class: 'radio' do |span|
            span.use :input, :label => false
            span.use :label_text, :label => false 
          end
        end
      end
    end
    b.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    b.use :error, wrap_with: { tag: :span, class: "help-block text-danger" }
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
