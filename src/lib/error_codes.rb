module MeedanConstants
  class ErrorCodes
    UNAUTHORIZED = 1
    MISSING_PARAMETERS = 2
    ID_NOT_FOUND = 3
    INVALID_VALUE = 4
    UNKNOWN = 5
    AUTH = 6
    WARNING = 7
    MISSING_OBJECT = 8
    DUPLICATED = 9
    ALL = %w(UNAUTHORIZED MISSING_PARAMETERS ID_NOT_FOUND INVALID_VALUE UNKNOWN AUTH WARNING MISSING_OBJECT DUPLICATED)
  end
end
