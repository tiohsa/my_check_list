class CheckItem < ActiveRecord::Base
    belongs_to :issue
    # accepts_nested_attributes_for :text, reject_if: lambda { |attributes| attributes['text'].blank? }
end
  