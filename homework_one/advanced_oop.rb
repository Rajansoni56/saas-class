module ClassExtensions

  # Defines the attr_name and attr_name_history methods.
  # The _history method will start with a nil element in the array
  def define_readers(attr_name)
    attr_reader attr_name

    define_method "#{attr_name}_history" do
      eval("@#{attr_name}_history ||= [ nil ]")
    end
  end

  # Defines the attr_name= method with the history management.
  # I couldn't get it working with `define_method`, so I opted
  # for the `class_eval` approach (which I feel less happy about).
  def define_writter(attr_name)
    code = <<-CODE
      def #{attr_name}=(val)
        @#{attr_name} = val
        #{attr_name}_history # Lazy eval
        @#{attr_name}_history << val
      end
    CODE
    class_eval code
  end

  # Creates a reader and writter method for the attribute names
  # passed. Additionally creates an attr_name_history that will
  # store the values of the given `attr_name` in an array.
  #
  # The first element of the _history array is always `nil`.
  #
  # For example:
  #
  # class Foo
  #   attr_accessor_with_history :bar, :pawa
  # end
  #
  # f = Foo.new
  # f.bar = 3
  # f.bar = 4
  # f.bar = :hello
  # f.bar_history  # => [nil, 3, 4, :hello]

  def attr_accessor_with_history(*attr_names)
    attr_names.each do |attr_name|
      attr_name = attr_name.to_s

      define_readers(attr_name)
      define_writter(attr_name)
    end
  end
end

Class.send(:include, ClassExtensions)

class Foo
  attr_accessor_with_history :bar, :pawa
end
