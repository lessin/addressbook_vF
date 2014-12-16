add gems

create model for claims
rails g model Claim subject:string verb:string object:string author:string

create modle for bycrypt
rails g model User username:string password:string password_diget:string admin:boolean displayname:string

    <% @claims.each do |claim| %>

      <%= claim.subject %><br>

    <% end %>
