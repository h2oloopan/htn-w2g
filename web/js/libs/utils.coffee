define ['jquery'], ($) ->
	return utils = 
		keys: (obj) ->
			if !Object.keys
                func = (obj) ->
                    hasOwnProperty = Object.prototype.hasOwnProperty
                    if typeof obj != 'object' && (typeof obj != 'function' || obj == null)
                        throw new TypeError('Object.keys called on non-object');
                        return

                    result = []
                    result.push prop for prop of obj when hasOwnProperty.call obj, prop
                    return result
                return func obj
            else
                return Object.keys(obj)
		serialize: (element, trim) ->
        	if !trim?
                trim = false

            o = {}
            if $(element).is 'form'
                form = element
            else
                form = $('<form></form>').append $(element).clone()

            a = form.serializeArray()
            $.each a, ->
                if o[@name] != undefined
                    if !o[@name].push
                        o[@name] = [o[@name]]
                    value = @value || ''
                    if trim
                        value = $.trim value
                    o[@name].push value
                else
                    value = @value || ''
                    if trim
                        value = $.trim value
                    o[@name] = value

            return o