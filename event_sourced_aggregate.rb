module Sample
  class EventSourcedAggregate
    def apply_changes(event)
      apply(event)
      uncommitted_changes << event
    end

    def replay(events)
      events.each { |event| apply(event) }
    end

    def uncommitted_changes
      @uncommitted_changes ||= []
    end

    def mark_changes_as_committed
      uncommitted_changes.clear
    end
  end
end
