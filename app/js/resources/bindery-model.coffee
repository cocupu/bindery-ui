angular.module('curateDeps').factory('BinderyModel', ['$resource', 'MemoService', 'BinderyServer', ($resource, memoService, bindery) ->
        BinderyModel = $resource(bindery.baseUrl+'/models/:modelId.json', { modelId:'@id' }, {
            update: { method: 'PUT' },
            query: {
                method: 'GET'
                url: '/:identityName/:poolName/models.json'
                params: {poolName:'@poolName', identityName:'@identityName'}
                isArray: true
                transformResponse: (data, header) ->
                  wrapped = angular.fromJson(data);
                  angular.forEach(wrapped, (item, idx) ->
                      m = new BinderyModel(item)  #<-- replace each item with an instance of the resource object
                      wrapped[idx] = m
                      memoService.createOrUpdate("BinderyModel", m)
                  )
                  return wrapped;
            }
        })
        
        BinderyModel.prototype.update = () ->
          this.$update( (savedModel, putResponseHeaders) =>
            now = new Date()
            this.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
            this.dirty = false
          )
        
        BinderyModel.typeOptionsFor = (fieldType) ->
          associationTypes = [{label:"Associaton (Has Many)", id:"Has Many"}, {label:"Associaton (Has One)", id:"Has One"}]
          fieldTypes = [{label:"Text Field", id:"string"},{label:"Text Area", id:"textarea"}, {label:"Integer", id:"integer"}, {label:"Date", id:"date"}]
          if (["Has One", "Has Many"].indexOf(fieldType) > -1)
            return associationTypes
          else
            return fieldTypes

        BinderyModel.prototype.addField = () ->
          this.fields.push({name: "New Field", code:"", type:"text"})

        BinderyModel.prototype.addAssociation = () ->
          this.associations.push({name: "New Association", code:"", type:"Has Many"})

        BinderyModel.prototype.columnDefsFromModel = () ->
          if this.fields.length + this.associations.length > 5
            fixedColumnWidth = true
          fieldsDefs = $.map(this.fields, (f, i) ->
            columnDef = {
              field:"data['"+f.id+"']"
              displayName:f.name
              editableCellTemplate: '/assets/editField-textfield.html'
              enableSorting: true
            }
            if fixedColumnWidth
              columnDef["width"] = "120"
            return columnDef
          )
          associationsDefs = $.map(this.associations, (f, i) ->
            columnDef = {field:"associations['"+f.id+"']", displayName:f.name, width:"120"}
            if fixedColumnWidth
              columnDef["width"] = "120"
            return columnDef
          )
          return fieldsDefs.concat(associationsDefs)

        return BinderyModel;
    ])