module WaitAjax
  def finished_ajax_requests?
    page.evaluate_script("jQuery.active").zero?
  end

  def wait_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_ajax_requests?
    end
  end
end
