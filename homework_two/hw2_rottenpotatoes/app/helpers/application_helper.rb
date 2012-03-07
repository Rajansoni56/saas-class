module ApplicationHelper
  def active_if_params_has(action, value)
    "hilite" if params.fetch(action){ nil } == value
  end
end
