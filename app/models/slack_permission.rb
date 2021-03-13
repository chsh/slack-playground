class SlackPermission
  concerning :Listing do
    class_methods do
      def all
        list.join(',')
      end

      def list
        %w(calls:read
calls:write
channels:history
channels:read
channels:write
chat:write
dnd:read
dnd:write
emoji:read
files:read
files:write
groups:history
groups:read
groups:write
identify
identity.avatar
identity.basic
identity.email
identity.team
im:history
im:read
im:write
links:read
links:write
mpim:history
mpim:read
mpim:write
pins:read
pins:write
reactions:read
reactions:write
reminders:read
reminders:write
remote_files:read
remote_files:share
search:read
stars:read
stars:write
team:read
usergroups:read
usergroups:write
users:read
users:read.email
users:write
users.profile:read
users.profile:write
)
      end
    end
  end
end
